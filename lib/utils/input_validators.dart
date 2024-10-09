import 'package:flutter/material.dart';

String? firstNameValidator(String? value) {
  if (value!.isNotEmpty) return null;

  return "Enter your first name.";
}

String? lastNameValidator(String? value) {
  if (value!.isNotEmpty) return null;

  return "Enter your last name.";
}

String? phoneNumberValidator(String? value) {
  final bool phoneValid = RegExp(r"^(09|\+639)\d{9}$").hasMatch(value!);
  if (phoneValid) {
    return null;
  } else if (value.length <= 11 && !phoneValid) {
    return "Please use +63 phone number format";
  } else if (value.length <= 10 && value.isNotEmpty) {
    return "Input is too short.";
  } else {
    return "Enter an input.";
  }
}

String? gmailEmailValidator(String? value) {
  const String expectedDomain = '@gmail.com';

  if (value!.isEmpty) return "Enter your email.";

  if (value.endsWith('@$expectedDomain')) {
    return 'Invalid email domain. Use @$expectedDomain';
  }

  return null;
}

String? passwordValidator(String? value) {
  final bool passwordValid = RegExp(
          r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-.+=_]).{8,}$")
      .hasMatch(value!);
  if (passwordValid) {
    return null;
  }

  return "Password must be at least 8 characters, at least one uppercase, number, and special characters.";
}

String? cfrmPassValidator(
    String? value,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController) {
  final bool cfrmPasswordValid =
      passwordController.text == confirmPasswordController.text;
  if (cfrmPasswordValid) {
    return null;
  } else if (value!.isEmpty) {
    return 'Enter input.';
  } else {
    return "Password not match";
  }
}

String? accountNameValidator(String? value) {
  if (value != null && value.isEmpty) return "Account name is required";

  return null;
}

String? accountNumberValidator(String? value) {
  if (value != null && value.isEmpty) return "Card number is required";

  if (value!.length < 12) return "Input requires 12 characters";

  return null;
}

String? petNameValidator(String? value){
  if (value != null && value.isEmpty) return "Enter your pet name.";
}

String? weightValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Enter your pet's weight.";
  }

  final RegExp weightRegExp = RegExp(r"^[0-9]+(\.[0-9]{1,2})?$");
  if (weightRegExp.hasMatch(value)) {
    return null;
  }

  return "Enter a valid weight. Use a positive number with up to two decimal places.";
}

String? centavosValidator(String? value) {
  if (value != null && value.isEmpty) return "Amount is required";

  if (value!.contains(".")) return "Enter an amount without centavos";

  return null;
}

String? noteValidator(String? value) {
  if (value != null && value.isNotEmpty) {
    if (value.length > 200) {
      return "Notes should not exceed 200 characters.";
    }
  }
  return null;
}
