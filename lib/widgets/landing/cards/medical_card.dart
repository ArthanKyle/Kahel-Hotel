import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';


class MedicalCard extends StatelessWidget {
  final String title; // Title of the medical card
  final String details; // Additional details or description
  final VoidCallback onTap;

  const MedicalCard({
    Key? key,
    required this.title,
    this.details = '', // Default empty details
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
        minHeight: 120,
        maxHeight: 120,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorPalette.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: ColorPalette.accentBlack,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                details,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ColorPalette.accentBlack,
                ),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 20), // Optional icon
        ],
      ),
    )
    );
  }
}
