import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//水印
class WaterMarkDemo extends StatelessWidget {
  const WaterMarkDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      child: WaterMark(
          child: FlutterLogo(style: FlutterLogoStyle.horizontal),
          waterMark: "abcd"),
    );
  }
}

class WaterMark extends StatelessWidget {
  final Widget child;
  final String? waterMark;

  const WaterMark({super.key, required this.child, this.waterMark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CupertinoPopupSurface(
          child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                  sigmaX: waterMark != null ? 2 : 0,
                  sigmaY: waterMark != null ? 2 : 0),
              child: child),
        ),
        if (waterMark != null)
          Center(
              child: AspectRatio(
                  aspectRatio: 1,
                  child: Transform.rotate(
                      angle: -pi / 4,
                      child: FittedBox(child: Text(waterMark!)))))
      ],
    );
  }
}
