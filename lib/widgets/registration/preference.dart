import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';

class PreferencesDropdown extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(List<String>) onPreferencesChanged;

  const PreferencesDropdown({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.onPreferencesChanged,
    required List<String> selectedPreferences,
  }) : super(key: key);

  @override
  _PreferencesDropdownState createState() => _PreferencesDropdownState();
}

class _PreferencesDropdownState extends State<PreferencesDropdown> {
  List<String> _selectedPreferences = [];

  @override
  void initState() {
    super.initState();
    _selectedPreferences = widget.controller.text.isNotEmpty
        ? widget.controller.text.split(', ')
        : [];
  }

  void _updatePreferences(String value) {
    setState(() {
      if (_selectedPreferences.contains(value)) {
        _selectedPreferences.remove(value);
      } else {
        _selectedPreferences.add(value);
      }
      widget.controller.text = _selectedPreferences.join(', ');
      widget.onPreferencesChanged(_selectedPreferences);
    });
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
          onSelected: _updatePreferences,
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
                Flexible(
                  child: Text(
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
                      overflow: TextOverflow.ellipsis, // Avoid overflow
                    ),
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
