
import 'package:flutter/material.dart';

class VaccinationCard extends StatelessWidget {
  final bool isVaccinated;
  final VoidCallback onTap;

  const VaccinationCard({
    Key? key,
    required this.isVaccinated,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: isVaccinated ? Colors.orange : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            isVaccinated ? 'Fully Vaccinated' : 'Not Vaccinated',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}