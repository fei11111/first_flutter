import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ProgressButtonDemo extends StatelessWidget {
  const ProgressButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        ProgressButton(
          width: 100,
          height: 50,
          duration: Duration(seconds: 5),
          radius: 10,
        ),
        SizedBox(height: 10),
        ProgressButton(
          width: 50,
          height: 50,
          duration: Duration(seconds: 2),
          radius: 25,
        ),
        SizedBox(height: 10),
        ProgressButton(
          width: 50,
          height: 50,
          duration: Duration(seconds: 2),
          radius: 0,
        ),
      ],
    );
  }
}

class ProgressButton extends StatefulWidget {
  final Duration duration;
  final double width;
  final double height;
  final double radius;

  const ProgressButton(
      {super.key,
      required this.duration,
      required this.width,
      required this.height,
      required this.radius});

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  int _stage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _stage = 2;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    late String lable;
    Color? textColor;
    Color? bgColor;
    switch (_stage) {
      case 0:
        lable = "Send";
        textColor = Colors.white;
        bgColor = Colors.blue;
        break;
      case 1:
        lable = "Cancel";
        break;
      case 2:
        lable = "Done";
        textColor = Colors.grey;
        break;
    }
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius)),
          color: bgColor),
      child: InkWell(
        onTap: () {
          if (_stage == 0) {
            _controller.forward(from: 0.0);
            setState(() {
              _stage = 1;
            });
          } else {
            _controller.reset();
            setState(() {
              _stage = 0;
            });
          }
        },
        borderRadius: BorderRadius.circular(widget.radius),
        child: CustomPaint(
            painter: MyPainter(
                widget.width, widget.height, widget.radius, _controller),
            child: Center(
                child: Text(lable,
                    style: TextStyle(color: textColor, fontSize: 13)))),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class MyPainter extends CustomPainter {
  final double width;
  final double height;
  final double radius;
  final AnimationController _controller;

  late Paint mPaint;
  late Paint mPathPaint;
  late RRect rect;
  late PathMetric metrics;

  MyPainter(this.width, this.height, this.radius, this._controller)
      : super(repaint: _controller) {
    mPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 2;
    mPathPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 2;
    rect = RRect.fromLTRBR(0, 0, width, height, Radius.circular(radius));
    var path = Path()..addRRect(rect);
    metrics = path.computeMetrics().single;
  }

  @override
  void paint(Canvas canvas, Size size) {
     var currentIndex = metrics.length * _controller.value;
    var path = Path();
    double startPoint = metrics.length / 4 + max(height / 2 - radius, 0);
    path.addPath(metrics.extractPath(startPoint, currentIndex + startPoint),
        Offset.zero);
    path.addPath(
        metrics.extractPath(0, currentIndex - metrics.length + startPoint),
        Offset.zero);
    canvas.drawRRect(rect, mPaint);
    canvas.drawPath(path, mPathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
