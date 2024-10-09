import 'package:flutter/material.dart';

class Add extends StatelessWidget {
  final VoidCallback onTap;
  const Add({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: onTap,
        icon: const Icon(
          Icons.add_circle_outline,
          color: Color(0xff585858),
          size: 30,
        ),
      ),
    );
  }
}