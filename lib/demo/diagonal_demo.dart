import 'package:flutter/material.dart';

class DiagonalDemo extends StatelessWidget {
  const DiagonalDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Diagonal(
      children: [
        FlutterLogo(size: 100),
        Container(width: 100, height: 50, color: Colors.green),
        Text("dfadfadf"),
        Container(color: Colors.redAccent, width: 50, height: 200),
        AnimatedContainer(
          duration: Duration(seconds: 1),
          width: 30,
          height: 30,
          decoration: const BoxDecoration(shape: BoxShape.circle,color: Colors.black),
        )
      ],
    );
  }
}

class Diagonal extends StatelessWidget {
  final List<Widget> children;

  const Diagonal({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(delegate: DiagonalDelegate(), children: [
      for (int i = 0; i < children.length; i++)
        LayoutId(id: i, child: children[i])
    ]);
  }
}

class DiagonalDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    Offset offset = Offset.zero;
    for (int i = 0;; i++) {
      if (hasChild(i)) {
        var childSize = layoutChild(i, BoxConstraints.loose(size));
        positionChild(i, offset);
        offset +=Offset(childSize.width, childSize.height);
      } else {
        break;
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
