import 'dart:math';

import 'package:intl/intl.dart';

String formatMoney(double amount) {
  final formatter = NumberFormat.currency(
    symbol: 'P ',
    decimalDigits: 2,
  );

  return formatter.format(amount);
}

String getLastFourDigits(String input) {
  // Convert the string to integer
  int? number = int.tryParse(input);

  if (number == null) {
    // Handle invalid input
    return "Invalid input";
  }

  // Get the last four digits using string manipulation
  String lastFourDigits =
      number.toString().substring(max(0, number.toString().length - 4));

  return lastFourDigits;
}
