import 'package:flutter/material.dart';

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> {
  bool _big = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: _big ? 100 : 50,
        height: 50,
        duration: const Duration(seconds: 1),
        child: Material(
          color: Colors.blue,
          elevation: 4,
          shape: const StadiumBorder(),
          child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () {
                setState(() {
                  _big = !_big;
                });
              },
              child:AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: _big
                    ? const Text("data")
                    : const Icon(Icons.arrow_right_alt)),
              )
        ));
  }
}
