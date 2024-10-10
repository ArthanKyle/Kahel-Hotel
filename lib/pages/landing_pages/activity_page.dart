import 'package:flutter/material.dart';
import 'package:kahel/utils/index_provider.dart';

import '../../api/pet.dart';
import '../../constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/analytics/activity_card.dart';
import '../../widgets/analytics/steps_card.dart';
import '../../widgets/landing/cards/sleep_card.dart';
import '../../widgets/universal/auth/arrow_back.dart';

class ActivityTracker extends StatefulWidget {
  const ActivityTracker({super.key});

  @override
  State<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    // Handle case where user is not authenticated
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('User not authenticated.'),
        ),
      );
    }

    // Extract UID from the user
    final uid = user!.uid;

    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: ArrowBack(onTap: () {
                    changePage(index: 0, context: context);
                  }
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                SizedBox(width: 10),
                Text(
                  'Activity Tracker',
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
            const Row(
              children: [
                ActivityCard(
                  title: "Time Feed",
                  subtitle: "5 mins ago",
                  iconPath: "assets/images/icons/dog-food.png",
                  subtitleIconPath: "assets/images/icons/clock.png",
                ),
                SizedBox(width: 16),
                ActivityCard(
                  title: "Playtime Time",
                  subtitle: "30 mins ago",
                  iconPath: "assets/images/icons/playing.png",
                  subtitleIconPath: "assets/images/icons/clock.png",
                ),
              ],
            ),
            const SizedBox(height: 5),
            StreamBuilder<double>(
              stream: getPetWalkProgress(uid: uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return StepsCard(
                    iconPath: "assets/images/icons/dog-with-belt-walking-with-a-man.png",
                    progress: snapshot.data ?? 0,
                    onTap: () { changePage(index: 1, context: context); },
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
            const SizedBox(height: 10),
            const SleepCard(
              iconPath: "assets/images/icons/pet-bed.png",
              sleepTitle: "Duration",
              duration: "2 hrs 30 mins",
              sleepInformation: "Sleep Information",
              sleepTime: "11:30 AM",
              wakeUpTime: "1:00 PM",
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
