import 'package:flutter/material.dart';

class CollectionButton extends StatelessWidget {
  const CollectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(
        Icons.star,
        color: Colors.blue,
      ),
      label: const Text(
        "收藏111111111111111111111111111111111111111111",
        style: TextStyle(color: Colors.blue),
      ),
      style: ButtonStyle(
          side: WidgetStateProperty.all(
              const BorderSide(color: Colors.blue, width: 2.0))),
    );
  }
}
