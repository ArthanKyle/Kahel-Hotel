import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kahel/utils/index_provider.dart';
import '../../constants/colors.dart';
import '../../models/pet.dart';
import '../../widgets/analytics/activity_card.dart';
import '../../widgets/analytics/steps_card.dart';
import '../../widgets/landing/cards/sleep_card.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import '../../api/pet.dart';

class ActivityTracker extends StatefulWidget {
  const ActivityTracker({super.key});

  @override
  State<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> {
  User? user;
  List<PetModel> pets = [];
  String? selectedPetId;
  String? selectedPetName;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _fetchUserPets(user!.uid);
    }
  }

  Future<void> _fetchUserPets(String uid) async {
    try {
      final petQuery = await FirebaseFirestore.instance
          .collection('pets')
          .where('uid', isEqualTo: uid)
          .get();

      setState(() {
        pets = petQuery.docs.map((doc) => PetModel.fromSnapshot(doc)).toList();

        if (pets.isNotEmpty) {
          selectedPetId = pets[0].petId; // Default to first pet
          selectedPetName = pets[0].petName;
        }
      });
    } catch (e) {
      print('Error fetching pets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('User not authenticated.')),
      );
    }

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
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
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
            const SizedBox(height: 20),

            // Pet selection dropdown
            DropdownButton<String>(
              value: selectedPetId,
              hint: Text('Select a pet'),
              items: pets.map((pet) {
                return DropdownMenuItem<String>(
                  value: pet.petId, // Assume pet is never null here
                  child: Text(pet.petName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPetId = value;
                  selectedPetName = pets.firstWhere((pet) => pet.petId == value).petName;
                });
              },
            ),

            Text('Activity for: ${selectedPetName ?? 'No pet selected'}'),
            const SizedBox(height: 20),

            // Example activity cards and other widgets
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
                  title: "Playtime",
                  subtitle: "30 mins ago",
                  iconPath: "assets/images/icons/playing.png",
                  subtitleIconPath: "assets/images/icons/clock.png",
                ),
              ],
            ),
            const SizedBox(height: 5),

            // StreamBuilder for pet walking activity
            StreamBuilder<double>(
              stream: selectedPetId != null
                  ? getPetWalkProgress(uid: uid, petId: selectedPetId!)
                  : Stream.value(0.0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return StepsCard(
                    iconPath: "assets/images/icons/dog-with-belt-walking-with-a-man.png",
                    progress: snapshot.data ?? 0,
                    onTap: () {
                      changePage(index: 1, context: context);
                    },
                  );
                } else {
                  return Center(child: Text('No walking activity data available.'));
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
