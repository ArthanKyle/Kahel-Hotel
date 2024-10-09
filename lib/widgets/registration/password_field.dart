import 'package:flutter/material.dart';
import 'package:kahel/constants/borders.dart';
import 'package:kahel/constants/colors.dart';

class PasswordField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(String) validator;
  const PasswordField(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.validator});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool passwordVisible = false;
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
          controller: widget.controller,
          validator: (value) {
            return widget.validator(widget.controller.text);
          },
          obscureText: !passwordVisible,
          cursorColor: ColorPalette.accentBlack,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 18.5),
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
            errorMaxLines: 2,
            suffixIcon: IconButton(
              color: ColorPalette.primary,
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          style: const TextStyle(
            color: ColorPalette.accentBlack,
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
