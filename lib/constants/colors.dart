import 'package:flutter/material.dart';

class ColorPalette {
  static const Color primary = Color(0xFFFEA82F);
  static const Color secondary = Color(0xFFF6CA8E);

  // Either of these will be in our fonts or background
  static const Color accentDarkWhite = Color(0xffd9d9d9);
  static const Color accent = Color(0xFFF6CA8E);
  static const Color accentWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color accentBlack = Color(0xFF171717);
  static const Color bgColor = Color(0xffF1FDF8);
  static const Color errorColor = Color(0xffDC2E2E);
  static const Color gray = Color(0xffC3C3C3);
  static const Color greyish = Color(0xFF848484);
  static const Color skyBlue = Color(0xff6282E4);
  static const Color darkBlue = Color(0xff233C8A);
  static const Color darkorange = Color (0xFFC88605);
  static const Color accentOrange = Color(0xFFFBB42A);
  static const Color textfieldColor = Color(0xffCCCCCC);


  // Define a gradient here
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      secondary, // Secondary color
      primary,   // Primary color
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
