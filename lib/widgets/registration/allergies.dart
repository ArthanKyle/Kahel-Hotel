import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/strings.dart';


class AllergiesDropdown extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(List<String>) onAllergiesChanged;

  const AllergiesDropdown({
    super.key,
    required this.labelText,
    required this.controller,
    required this.onAllergiesChanged,
  });

  @override
  _AllergiesDropdownState createState() => _AllergiesDropdownState();
}

class _AllergiesDropdownState extends State<AllergiesDropdown> {
  List<String> _selectedAllergies = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    // Initialize _selectedAllergies with the controller's text if not empty
    _selectedAllergies = widget.controller.text.isNotEmpty
        ? widget.controller.text.split(', ')
        : [];
  }

  void _updateAllergies(List<String> updatedAllergies) {
    setState(() {
      _selectedAllergies = updatedAllergies;
      widget.controller.text = updatedAllergies.join(', ');
    });
    widget.onAllergiesChanged(_selectedAllergies);
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
        PopupMenuButton<String>(
          onSelected: (value) {
            List<String> updatedAllergies = List.from(_selectedAllergies);
            if (updatedAllergies.contains(value)) {
              updatedAllergies.remove(value);
            } else {
              updatedAllergies.add(value);
            }
            _updateAllergies(updatedAllergies);
          },
          itemBuilder: (BuildContext context) {
            return KahelStrings.foodAllergies.map((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: ColorPalette.accentBlack,
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedAllergies.contains(value))
                      const Icon(Icons.check, color: ColorPalette.primary),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18.5),
            decoration: BoxDecoration(
              color: ColorPalette.bgColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _selectedAllergies.isEmpty
                    ? Colors.transparent
                    : ColorPalette.primary,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedAllergies.isEmpty
                      ? 'Select Allergies'
                      : _selectedAllergies.join(', '),
                  style: TextStyle(
                    color: _selectedAllergies.isEmpty
                        ? ColorPalette.accentBlack.withOpacity(0.5)
                        : ColorPalette.accentBlack,
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: ColorPalette.accentBlack),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
