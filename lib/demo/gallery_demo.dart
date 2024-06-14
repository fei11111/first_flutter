import 'package:flutter/material.dart';

class GalleryDemo extends StatefulWidget {
  const GalleryDemo({super.key});

  @override
  State<GalleryDemo> createState() => _GalleryDemoState();
}

class _GalleryDemoState extends State<GalleryDemo> {
  late ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scrollbar(
            controller: controller,
            child: GalleryView(
                controller: controller,
                itemCount: 101,
                itemBuilder: (context, index) {
                  return Container(color: Colors.primaries[index % 18]);
                })),
        IconButton(
            onPressed: () {
              controller.animateTo(-20,
                  duration: Duration(seconds: 1), curve: Curves.easeInOut);
            },
            icon: Icon(Icons.upload_rounded, color: Colors.white))
      ],
    );
  }
}

class GalleryView extends StatefulWidget {
  final ScrollController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  Duration? duration;
  int minPerRow = 1;
  int maxPerRow = 10;

  GalleryView(
      {super.key,
      required this.controller,
      required this.itemCount,
      required this.itemBuilder,
      this.minPerRow = 1,
      this.maxPerRow = 7,
      this.duration = const Duration(seconds: 1)});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  double minWidth = 0;
  double maxWidth = 0;
  double currentWidth = 0;
  double preWidth = 0;
  double screenWidth = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      currentWidth = (preWidth * details.scale).clamp(minWidth, maxWidth);
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    int row = (maxWidth / currentWidth)
        .round()
        .clamp(widget.minPerRow, widget.maxPerRow);
    setState(() {
      currentWidth = maxWidth / row;
    });
  }

  void _onScaleStart(details) {
    widget.controller.jumpTo(0);
    preWidth = currentWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth != screenWidth) {
          screenWidth = constraints.maxWidth;
          minWidth = screenWidth / widget.maxPerRow;
          maxWidth = screenWidth / widget.minPerRow;
          currentWidth = minWidth;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            int row = (maxWidth / currentWidth)
                .round()
                .clamp(widget.minPerRow, widget.maxPerRow);
            setState(() {
              currentWidth = maxWidth / row;
            });
          });
        }
        return GestureDetector(
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onScaleEnd: _onScaleEnd,
            child: _buildListView());
      },
    );
  }

  _buildListView() {
    int count = (maxWidth / currentWidth).ceil();
    return ListView.builder(
        controller: widget.controller,
        itemCount: (widget.itemCount / count).ceil(),
        itemExtent: currentWidth,
        itemBuilder: (context, index) {
          return OverflowBox(
            maxWidth: double.infinity,
            child: Row(children: [
              for (int i = 0; i < count; i++)
                if (index * count + i < widget.itemCount)
                  _buildChild(index * count + i)
            ]),
          );
        });
  }

  _buildChild(index) {
    return SizedBox(
      width: currentWidth,
      height: currentWidth,
      child: AnimatedSwitcher(
        duration: widget.duration!,
        child: KeyedSubtree(
          key: ValueKey(index),
          child: widget.itemBuilder(context, index),
        ),
      ),
    );
  }
}
