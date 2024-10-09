import 'package:flutter/material.dart';

import '../../../constants/borders.dart';
import '../../../constants/colors.dart';


class NotesTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(String) validator;
  final Function(String)? onChange;
  final String? hintText;
  final int? maxLength;
  final int maxLines;

  const NotesTextField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.validator,
    this.hintText,
    this.onChange,
    this.maxLength,
    this.maxLines = 3, // Default maxLines set to 3 for multi-line input
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            color: ColorPalette.accentBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          cursorColor: ColorPalette.accentBlack,
          validator: (value) {
            return validator(controller.text);
          },
          onChanged: (value) {
            if (onChange == null) return;
            onChange!(value);
          },
          maxLength: maxLength,
          maxLines: maxLines,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18.5),
            enabledBorder: Inputs.enabledBorder,
            focusedBorder: Inputs.focusedBorder,
            errorBorder: Inputs.errorBorder,
            focusedErrorBorder: Inputs.errorBorder,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: ColorPalette.bgColor,
            errorStyle: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal,
              color: ColorPalette.errorColor,
              fontSize: 12,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: ColorPalette.accentBlack,
              fontFamily: "Poppins",
              fontSize: 11.5,
              fontWeight: FontWeight.w300,
            ),
          ),
          style: const TextStyle(
            color: ColorPalette.accentBlack,
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
