
import 'package:flutter/material.dart';
import 'package:kahel/constants/colors.dart';

class ActivityBox extends StatelessWidget {
  final String name;
  final String filePath;
  final VoidCallback onTap;
  final double iconSizeWidth;
  final double iconSizeHeight;
  const ActivityBox({
    super.key,
    required this.name,
    required this.filePath,
    required this.onTap,
    required this.iconSizeWidth,
    required this.iconSizeHeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  filePath,
                  height: iconSizeHeight,
                  width: iconSizeWidth,
                  color: ColorPalette.primary,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: ColorPalette.accentBlack,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 25,
            color: Color(0xff585858),
          ),
        ],
      ),
    );
  }
}
