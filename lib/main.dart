import 'package:flutter/material.dart';
import 'package:kahel/pages/auth/create_mpin_page.dart';
import 'package:kahel/pages/auth/enter_mpin_page.dart';
import 'package:kahel/pages/auth/log_in_page.dart';
import 'package:kahel/pages/auth/registration_page.dart';
import 'package:kahel/pages/auth/registration_pet_page.dart';
import 'package:kahel/pages/auth/start_pages/onboarding_page.dart';
import 'package:kahel/pages/landing_page.dart';
import 'package:kahel/pages/landing_pages/book_page.dart';
import 'package:kahel/pages/landing_pages/payment_page.dart';
import 'package:kahel/pages/landing_pages/pet_profile_page.dart';
import 'package:kahel/pages/page_handler.dart';
import 'package:kahel/pages/profile_page.dart';
import 'package:kahel/utils/booking_provider.dart';
import 'package:kahel/utils/index_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_check.dart';
import 'constants/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  await Hive.openBox("myRegistrationBox");
  await Hive.openBox("sessions");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageIndexProvider()),
        ChangeNotifierProvider(create: (context) => BookingDetailsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Kahel',
      theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: ColorPalette.primary,
          secondary: ColorPalette.secondary,
        ),
      ),
      initialRoute: '/auth',
      routes: {
        "/landing" : (context) => const LandingPage(),
        "/auth": (context) => const AuthCheck(),
        "/start": (context) => const OnboardingScreen(),
        "/login": (context) => const SignInPage(),
        "/registration": (context) => const RegistrationPage(),
        "/create-mpin": (context) => const CreateMPINPage(),
        "/enter-mpin": (context) => const EnterMPINPage(),
        "/": (context) => const PageHandler(),
        "/profile": (context) => const ProfilePage(),
        "/pet_registration" : (context) => const RegistrationPetPage(),
        "/booking": (context) => const BookService(),
        "/pet_profile": (context) => const PetProfilePage(),


      },
    );
  }
}