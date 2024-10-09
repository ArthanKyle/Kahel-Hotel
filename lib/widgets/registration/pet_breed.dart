import 'package:flutter/material.dart';

import '../../../constants/borders.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';


class PetBreedDropdown extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;

  const PetBreedDropdown({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  State<PetBreedDropdown> createState() => _PetBreedDropdownState();
}

class _PetBreedDropdownState extends State<PetBreedDropdown> {
  String? selectedBreed;

  @override
  void initState() {
    super.initState();
    selectedBreed = widget.controller.text; // Initialize selectedBreed with the controller's text
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            color: ColorPalette.accentBlack,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedBreed!.isNotEmpty ? selectedBreed : null, // Handle null values
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              selectedBreed = value;
              widget.controller.text = value; // Update the controller's text
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) return "Please select a pet breed.";
            return null;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18.5),
            enabledBorder: Inputs.enabledBorder,
            focusedBorder: Inputs.focusedBorder,
            errorBorder: Inputs.errorBorder,
            focusedErrorBorder: Inputs.errorBorder,
            filled: true,
            fillColor: ColorPalette.bgColor,
            errorStyle: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal,
              color: ColorPalette.errorColor,
              fontSize: 12,
            ),
          ),
          items: KahelStrings.breed.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  color: ColorPalette.accentBlack,
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
