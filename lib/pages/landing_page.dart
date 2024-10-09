import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kahel/widgets/universal/dialog_info.dart';
import '../constants/colors.dart';
import '../utils/index_provider.dart';
import '../widgets/landing/cards/custom_card.dart';
import '../widgets/universal/user_status_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final myRegBox = Hive.box("sessions");
  late String? name = myRegBox.get("name");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 40),
            HeaderBar(
              subText: "welcome back",
              headText: name ?? "name",
              onPressProfile: () => changePage(index: 3, context: context),
              onPressNotif: () {},
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: ColorPalette.backgroundGradient,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    height: 0,
                    letterSpacing: 0.12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomCard(
              iconPath: 'assets/images/icons/calendar.png',
              title: 'Book a Service',
              onTap: () {
                changePage(index: 4, context: context);
              },
            ),
            CustomCard(
              iconPath: 'assets/images/icons/dog.png',
              title: 'Pet Profile',
              onTap: () {
                changePage(index: 6, context: context);
              }
            ),
            CustomCard(
              iconPath: 'assets/images/icons/loyalty.png',
              title: 'Loyalty and Rewards',
              onTap: () {
               changePage(index: 2, context: context);
              },
            ),
            CustomCard(
              iconPath: 'assets/images/icons/activity-tracker.png',
              title: 'Activity Tracker',
              onTap: () {
                changePage(index: 5, context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

