import 'package:flutter/material.dart';

class BannerDemo extends StatelessWidget {
  const BannerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Banner(
          message: "check",
          location: BannerLocation.topEnd,
          color: Colors.redAccent,
          child: Container(width: 300, height: 150, color: Colors.grey)),
    );
    // return Stack(children: [
    //   Container(width: 250, height: 130, color: Colors.grey),
    //   Positioned(
    //       right: 0,
    //       top: sqrt(150*150/2-sqrt2*150*40 + 40*40),
    //       child: Transform.rotate(
    //         alignment: Alignment.bottomRight,
    //         angle: pi/4,
    //         child: Container(
    //           width: 150,
    //           height: 40,
    //           color: Colors.red[200],
    //         ),
    //       ))
    // ]);
  }
}
