import 'package:flutter/material.dart';

import '../../api/auth.dart';
import '../../constants/borders.dart';
import '../../constants/colors.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import '../../widgets/universal/auth/auth_info.dart';
import '../../widgets/universal/dialog_info.dart';
import '../../widgets/universal/dialog_loading.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _inputControllerEmail = TextEditingController();
  final _inputControllerPassword = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Make sure the container takes full width
        height: double.infinity, // Make sure the container takes full height
        decoration: const BoxDecoration(
          gradient: ColorPalette.backgroundGradient, // Use the defined gradient
        ),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), // Add padding here
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              ArrowBack(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, "/start", (route) => false)),
              const SizedBox(height: 20),
              const AuthInfo(
                  headText: "Log in your account", subText: ""),
              const SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    " Email",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _inputControllerEmail,
                    cursorColor: ColorPalette.accentBlack,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide an email";
                      }
                      bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                          .hasMatch(value);
                      if (!emailValid) {
                        return "Invalid email format";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 18.5),
                      enabledBorder: Inputs.enabledBorder,
                      focusedBorder: Inputs.focusedBorder,
                      errorBorder: Inputs.errorBorder,
                      focusedErrorBorder: Inputs.errorBorder,
                      filled: true,
                      fillColor: const Color(0xffE8E8E8),
                      errorStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        color: ColorPalette.errorColor,
                        fontSize: 12,
                      ),
                    ),
                    style: const TextStyle(
                      color: ColorPalette.accentBlack,
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    " Password",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                  TextFormField(
                    controller: _inputControllerPassword,
                    obscureText: !_passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    cursorColor: ColorPalette.accentBlack,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide a password";
                      } else if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 18.5),
                      enabledBorder: Inputs.enabledBorder,
                      focusedBorder: Inputs.focusedBorder,
                      errorBorder: Inputs.errorBorder,
                      focusedErrorBorder: Inputs.errorBorder,
                      suffixIcon: IconButton(
                        color: ColorPalette.primary,
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: ColorPalette.primary,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xffE8E8E8),
                      errorStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        color: ColorPalette.errorColor,
                        fontSize: 12,
                      ),
                    ),
                    style: const TextStyle(
                      color: ColorPalette.accentBlack,
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Forgot password",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ColorPalette.accentWhite,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  DialogLoading(subtext: "Logging in...").build(context);

                  String email = _inputControllerEmail.text.trim();
                  String password = _inputControllerPassword.text.trim();

                  AuthResponse res =
                  await signIn(email: email, password: password);

                  if (!mounted) return;

                  Navigator.of(context, rootNavigator: true).pop();

                  if (res.userCredential == null) {
                    DialogInfo(
                      headerText: "Error",
                      subText: res.errorMessage!,
                      confirmText: "Try again",
                      onCancel: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      onConfirm: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ).build(context);
                    return;
                  }

                  Navigator.pushNamedAndRemoveUntil(
                      context, "/enter-mpin", (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  backgroundColor: ColorPalette.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Log in",
                  style: TextStyle(
                    color: ColorPalette.accentBlack,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/registration"),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.accentWhite,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
