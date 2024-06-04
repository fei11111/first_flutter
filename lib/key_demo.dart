import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,v
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// 类似RecorderableListView
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _colors = <Color>[];
  var _color;

  int _dragIndex = -1;
  final GlobalKey _globalKey = GlobalKey();
  double containerTop = 0.0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    _colors = List.generate(8, (index) {
      return _color[100 * (index + 1)];
    });
    setState(() {
      _colors.shuffle();
    });
  }

  void _move(PointerMoveEvent event) {
    if (_dragIndex < 0) return;
    double y = event.position.dy - containerTop;
    if (y > (_dragIndex + 1) * Box.HEIGHT) {
      if (_dragIndex == _colors.length - 1) return;
      setState(() {
        Color old = _colors.removeAt(_dragIndex);
        _colors.insert(_dragIndex + 1, old);
        _dragIndex++;
      });
    } else if (y < _dragIndex * Box.HEIGHT) {
      if (_dragIndex == 0) return;
      setState(() {
        Color old = _colors.removeAt(_dragIndex);
        _colors.insert(_dragIndex - 1, old);
        _dragIndex--;
      });
    }
  }

  bool _check() {
    for (int index = 0; index < _colors.length - 1; index++) {
      if (_colors[index].computeLuminance() >
          _colors[index + 1].computeLuminance()) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double left =
        MediaQuery.of(context).size.width / 2 - Box.WIDTH / 2 - Box.SPACING / 2;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh_sharp),
                color: Colors.white)
          ],
        ),
        body: Listener(
            onPointerMove: _move,
            child: Flex(direction: Axis.vertical, children: [
              const Text("HELLO", style: TextStyle(fontSize: 35)),
              Container(
                  width: Box.WIDTH,
                  margin: const EdgeInsets.all(Box.SPACING),
                  height: Box.HEIGHT - 2 * Box.SPACING,
                  color: _color[900],
                  child: const Icon(Icons.lock, color: Colors.white)),
              Expanded(
                  flex: 1,
                  child: Stack(
                      fit: StackFit.expand,
                      key: _globalKey,
                      alignment: Alignment.topCenter,
                      children: List.generate(_colors.length, (index) {
                        return Box(
                            color: _colors[index],
                            left: left,
                            top: Box.HEIGHT * index,
                            onDragStart: (Color color) {
                              _dragIndex = _colors.indexOf(color);
                              var renderBox = _globalKey.currentContext!
                                  .findRenderObject() as RenderBox;
                              containerTop =
                                  renderBox.localToGlobal(Offset.zero).dy;
                            },
                            onDragEnd: () {
                              _dragIndex = -1;
                              if (_check()) {
                                print("成功");
                              } else {
                                print("失败");
                              }
                            });
                      })))
            ])));
  }
}

class Box extends StatefulWidget {
  static const WIDTH = 200.0;
  static const HEIGHT = 50.0;
  static const SPACING = 2.0;

  final Color color;
  final double left;
  final double top;

  final Function(Color) onDragStart;
  final Function onDragEnd;

  Box(
      {required this.color,
      required this.left,
      required this.top,
      required this.onDragStart,
      required this.onDragEnd})
      : super(key: ValueKey(color));

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: widget.left,
      top: widget.top,
      duration: const Duration(milliseconds: 300),
      child: Draggable(
        onDragStarted: () {
          widget.onDragStart(widget.color);
        },
        onDragEnd: (_) {
          widget.onDragEnd();
        },
        feedback: Container(
          width: Box.WIDTH,
          margin: const EdgeInsets.all(Box.SPACING),
          height: Box.HEIGHT - 2 * Box.SPACING,
          color: widget.color,
        ),
        childWhenDragging: const Offstage(offstage: false, child: null),
        child: Container(
          width: Box.WIDTH,
          margin: const EdgeInsets.all(Box.SPACING),
          height: Box.HEIGHT - 2 * Box.SPACING,
          color: widget.color,
        ),
      ),
    );
  }
}
