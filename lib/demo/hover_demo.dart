import 'dart:ui';

import 'package:flutter/material.dart';


//镂空的字
class HoverDemo extends StatelessWidget {
  const HoverDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return HoverText(text: "Hello",color: Colors.red,fontSize: 25);
  }
}

class HoverText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  double? borderWidth;

  HoverText(
      {super.key, required this.text, required this.color, required this.fontSize,this.borderWidth});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(text, style: TextStyle(fontSize: fontSize, foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth??4
          ..color = color)),
        Text(("Hello"),
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
      ],
    );
  }
}

