import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';  // Import flutter_typeahead

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
    selectedBreed = widget.controller.text;
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

        // Replace DropdownButtonFormField with TypeAheadFormField
        TypeAheadFormField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: widget.controller,
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
          ),
          suggestionsCallback: (pattern) {
            // Filter breeds that contain the input text (case insensitive)
            return KahelStrings.breed.where((breed) =>
                breed.toLowerCase().contains(pattern.toLowerCase()));
          },
          itemBuilder: (context, String suggestion) {
            return ListTile(
              title: Text(
                suggestion,
                style: const TextStyle(
                  color: ColorPalette.accentBlack,
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          onSuggestionSelected: (String suggestion) {
            // Update the selected breed and controller when a suggestion is selected
            setState(() {
              selectedBreed = suggestion;
              widget.controller.text = suggestion;
            });
          },
          noItemsFoundBuilder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No pet breeds found',
              style: const TextStyle(
                color: ColorPalette.errorColor,
                fontFamily: "Poppins",
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return "Please select or type a pet breed.";
            return null;
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
