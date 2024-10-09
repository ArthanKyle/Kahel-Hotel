import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../widgets/sign_in/onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: ColorPalette.backgroundGradient, // Apply the gradient
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                children: [
                  const OnboardingPage(
                    imagePath: "assets/images/icons/1stpickahel.png",
                    title: "Welcome to KAHEL HOTEL",
                    subtitle: "A place where every pet feels right at home. We provide comfort, care, and fun for your furry friends.",
                  ),
                  const OnboardingPage(
                    imagePath: "assets/images/icons/receptionn.png",
                    title: "KAHEL HOTEL",
                    subtitle: "At our pet hotel, we offer a range of services to keep your pets happy, healthy, and entertained during their stay.",
                  ),
                  OnboardingPage(
                    imagePath: "assets/images/icons/friendss.png",
                    title: "Ready to begin?",
                    subtitle: "Click 'Get Started' to create your pet's perfect stay with us!",
                    buttonText: "Get Started",
                    onButtonPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/login",
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40), // Adjust spacing here
              child: Center(
                child: Container(
                  width: 95,
                  height: 25,
                  child: Stack(
                    children: List.generate(
                      3, // Number of pages
                          (index) => Positioned(
                        left: index * 35.0, // Adjust spacing based on number of pages
                        top: 0,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: ShapeDecoration(
                            color: _currentPage == index
                                ? ColorPalette.accentWhite
                                : ColorPalette.greyish,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
