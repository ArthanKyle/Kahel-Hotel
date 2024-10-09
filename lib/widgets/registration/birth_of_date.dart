import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:kahel/constants/borders.dart';
import 'package:kahel/constants/colors.dart';

class BirthOfDateField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  const BirthOfDateField({
    super.key,
    required this.labelText,
    required this.controller,
  });
  @override
  State<BirthOfDateField> createState() => _BirthOfDateFieldState();
}

class _BirthOfDateFieldState extends State<BirthOfDateField> {
  DateTime selectedDate = DateTime.now();

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
        TextFormField(
          readOnly: true,
          onTap: () => _selectDate(context),
          cursorColor: ColorPalette.accentBlack,
          controller: widget.controller,
          validator: (value) {
            if (value!.isNotEmpty) return null;

            return "Please enter your birth of date!";
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 18.5),
            enabledBorder: Inputs.enabledBorder,
            focusedBorder: Inputs.focusedBorder,
            errorBorder: Inputs.errorBorder,
            focusedErrorBorder: Inputs.errorBorder,
            disabledBorder: Inputs.enabledBorder,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: ColorPalette.bgColor,
            errorStyle: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal,
              color: ColorPalette.errorColor,
              fontSize: 12,
            ),
          ),
          style: const TextStyle(
            color: ColorPalette.accentBlack,
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        DateFormat dateFormat = DateFormat("MM/dd/yyyy");

        widget.controller.text = dateFormat.format(selectedDate);
      });
    }
  }
}
