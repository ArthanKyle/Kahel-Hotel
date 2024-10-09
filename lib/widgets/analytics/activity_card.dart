import 'package:flutter/material.dart';
import 'package:kahel/constants/colors.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final String? subtitleIconPath; // Optional subtitle icon path
  final Widget? details;

  const ActivityCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.subtitleIconPath,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // Set a fixed width
      height: 180, // Set a fixed height
      padding: const EdgeInsets.all(16), // Adjust padding as needed
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorPalette.accentOrange,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, height: 80, color: Colors.black), // Adjust icon size
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16, // Adjust font size if needed
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the items horizontally
            children: [
              if (subtitleIconPath != null) ...[
                Image.asset(
                  subtitleIconPath!,
                  height: 16, // Adjust icon size
                  width: 16, // Adjust icon size
                  color: Colors.black,
                ),
                const SizedBox(width: 8), // Space between icon and text
              ],
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12, // Adjust font size if needed
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          if (details != null) ...[
            const SizedBox(height: 15),
            details!,
          ],
        ],
      ),
    );
  }
}
