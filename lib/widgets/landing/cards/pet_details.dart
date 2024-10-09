import 'package:flutter/material.dart';
import 'package:kahel/widgets/landing/cards/preference_card.dart';

import '../../../../constants/colors.dart';


class PetDetailsCard extends StatelessWidget {
  final String name;
  final String breed;
  final String gender;
  final String weight;
  final String birthday;
  final String preferences;
  final String allergies;
  final String profilePicturePath;

  const PetDetailsCard({
    Key? key,
    required this.name,
    required this.breed,
    required this.gender,
    required this.weight,
    required this.birthday,
    required this.preferences,
    required this.allergies,
    required this.profilePicturePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPalette.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: profilePicturePath.isNotEmpty
                    ? NetworkImage(profilePicturePath) as ImageProvider
                    : const AssetImage('assets/images/icons/pet_profile.png'),
                child: profilePicturePath.isEmpty
                    ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorPalette.accentBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      breed,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: ColorPalette.accentBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$gender • $weight kg',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: ColorPalette.accentBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      birthday,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: ColorPalette.accentBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PreferencesCard(
                  title: 'Preferences',
                  details: preferences,
                  icon: Icons.favorite,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PreferencesCard(
                  title: 'Allergies',
                  details: allergies,
                  icon: Icons.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

