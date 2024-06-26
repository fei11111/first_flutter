import 'dart:async';

import 'package:flutter/material.dart';

//数字滚动动画
class NumberDemo extends StatefulWidget {
  const NumberDemo({super.key});

  @override
  State<NumberDemo> createState() => _NumberDemoState();
}

class _NumberDemoState extends State<NumberDemo> {
  double _count = 1.0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_count == 9) _count = 0;
        _count++;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 1),
      tween: Tween(end: _count),
      builder: (BuildContext context, value, Widget? child) {
        final whole = value ~/ 1;
        final decimal = value - whole;
        return Stack(children: [
          Positioned(
              top: -100 * decimal, //0~-100
              child: Text("$whole", style: const TextStyle(fontSize: 100))),
          Positioned(
              top: 100 - 100 * decimal, //100~0
              child:
                  Text("${whole + 1}", style: const TextStyle(fontSize: 100)))
        ]);
      },
    );
  }
}
