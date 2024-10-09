import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';


class PreferencesCard extends StatelessWidget {
  final String title;
  final String details;
  final IconData icon;

  const PreferencesCard({
    Key? key,
    required this.title,
    required this.details,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ColorPalette.accentBlack),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.accentBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            details,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: ColorPalette.accentBlack,
            ),
          ),
        ],
      ),
    );
  }
}
