// MPINButton
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MPINButton extends StatelessWidget {
  final String textName;
  final VoidCallback onTap;

  const MPINButton({
    Key? key,
    required this.textName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        // Fixed width
        height: 60,
        // Fixed height
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: ColorPalette.accentWhite,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            textName,
            style: const TextStyle(
              fontSize: 22, // Slightly reduced font size
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}