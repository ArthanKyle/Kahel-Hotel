import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class SuccessBankLinkPage extends StatefulWidget {
  final String successMessage;
  const SuccessBankLinkPage({super.key, required this.successMessage});

  @override
  State<SuccessBankLinkPage> createState() => _SuccessBankLinkPageState();
}

class _SuccessBankLinkPageState extends State<SuccessBankLinkPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorPalette.primary,
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: ColorPalette.primary,
                  size: 60,
                ),
              ),
              Text(
                widget.successMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: ColorPalette.accentBlack,
                ),
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (route) => false);
                  },
                  child: const Text(
                    'Go back to Profile',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}