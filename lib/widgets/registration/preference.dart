import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/strings.dart';


class PreferencesDropdown extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(List<String>) onPreferencesChanged;
  final List<String> selectedPreferences;

  const PreferencesDropdown({
    super.key,
    required this.labelText,
    required this.controller,
    required this.onPreferencesChanged,
    required this.selectedPreferences,
  });

  @override
  State<PreferencesDropdown> createState() => _PreferencesDropdownState();
}

class _PreferencesDropdownState extends State<PreferencesDropdown> {
  late List<String> _selectedPreferences;

  @override
  void initState() {
    super.initState();
    _selectedPreferences = widget.controller.text.isNotEmpty
        ? widget.controller.text.split(', ')
        : [];
  }

  void _updatePreferences(List<String> updatedPreferences) {
    setState(() {
      _selectedPreferences = updatedPreferences;
      widget.controller.text = updatedPreferences.join(', ');
    });
    widget.onPreferencesChanged(_selectedPreferences);
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
            List<String> updatedPreferences = List.from(_selectedPreferences);
            if (updatedPreferences.contains(value)) {
              updatedPreferences.remove(value);
            } else {
              updatedPreferences.add(value);
            }
            _updatePreferences(updatedPreferences);
          },
          itemBuilder: (BuildContext context) {
            return KahelStrings.foodPreferences.map((String value) {
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
                    if (_selectedPreferences.contains(value))
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
                color: _selectedPreferences.isEmpty
                    ? Colors.transparent
                    : ColorPalette.primary,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedPreferences.isEmpty
                      ? 'Select Preferences'
                      : _selectedPreferences.join(', '),
                  style: TextStyle(
                    color: _selectedPreferences.isEmpty
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
