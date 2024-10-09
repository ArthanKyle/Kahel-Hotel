import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final bool isVaccinated;
  final bool isClickable;
  final VoidCallback? onTap; // Updated to allow nullable

  const InfoCard({
    Key? key,
    required this.title,
    required this.isVaccinated,
    required this.isClickable,
    this.onTap, // Updated to be optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isClickable && onTap != null ? onTap : null, // Safely handle onTap
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity, // Make the container take the full available width
        height: 120,
        decoration: BoxDecoration(
          color: isVaccinated ? ColorPalette.primary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isVaccinated
            ? const Center( // Center the text when fully vaccinated
          child: Text(
            'Fully Vaccinated',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: ColorPalette.accentBlack,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
