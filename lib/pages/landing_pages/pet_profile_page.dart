import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahel/widgets/landing/cards/medical_card.dart';
import 'package:kahel/widgets/landing/cards/vaccination_card.dart';
import 'package:kahel/widgets/universal/dialog_info.dart';
import 'package:kahel/widgets/universal/dialog_loading.dart';
import 'package:kahel/widgets/universal/dialog_vaccine.dart';
import '../../api/pet.dart';
import '../../constants/colors.dart';
import '../../models/pet.dart';
import '../../utils/index_provider.dart';
import '../../widgets/landing/cards/info_card.dart';
import '../../widgets/landing/cards/pet_details.dart';
import '../../widgets/universal/auth/add.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import '../auth/registration_pet_page.dart';

class PetProfilePage extends StatefulWidget {
  const PetProfilePage({super.key});

  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  String? petName;
  String? petId; // Added petId
  String petProfilePictureUrl = "";

  @override
  void initState() {
    super.initState();
    _loadPetData(); // Loading the pet data
  }

  Future<void> _loadPetData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot petsSnapshot = await FirebaseFirestore.instance
          .collection('pets')
          .where('uid', isEqualTo: user.uid)
          .limit(1) // Fetch only the first pet for performance
          .get();

      if (petsSnapshot.docs.isNotEmpty) {
        setState(() {
          petId = petsSnapshot.docs.first.id; // Set petId for use later
        });
      }
    }
  }

  Stream<bool> getPetVaccinationStatus() {
    if (petId == null) {
      return Stream.error("Pet ID is not available");
    }
    return FirebaseFirestore.instance
        .collection('pets')
        .doc(petId) // Use the petId to get vaccination status
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        throw Exception("No vaccination data available");
      }
      return snapshot.get('isVaccinated') ?? false; // Default to false if not present
    });
  }

  Stream<DocumentSnapshot> _getPetStream() {
    if (petId == null) {
      return Stream.empty(); // Return an empty stream if no petId
    }
    return FirebaseFirestore.instance
        .collection('pets')
        .doc(petId)
        .snapshots(); // Listen to real-time updates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  child: ArrowBack(
                    onTap: () {
                      // Now using named parameters for the changePage function
                      changePage(index: 0, context: context);
                    },
                  ),
                ),
                const Text(
                  "Pet Profile",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: ColorPalette.accentBlack,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Add(
                    onTap: () {
                      // Now using named parameters for the changePage function
                      changePage(index: 7, context: context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot>(
              stream: _getPetStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a placeholder while loading
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('No pet data available'));
                } else {
                  // Extract pet data and display
                  var petData = snapshot.data!.data() as Map<String, dynamic>;
                  PetModel pet = PetModel.fromJson(petData);
                  return PetDetailsCard(
                    name: pet.petName,
                    breed: pet.petBreed,
                    gender: pet.gender,
                    weight: pet.weight,
                    birthday: pet.birthday,
                    preferences: pet.preferences,
                    allergies: pet.allergies,
                    profilePicturePath: pet.profilePictureUrl,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
          StreamBuilder<bool>(
            stream: getPetVaccinationStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                bool isVaccinated = snapshot.data ?? false;

                return InfoCard(
                  title: 'Vaccination Status',
                  isVaccinated: isVaccinated,
                  isClickable: true, // Always set to true so the card is tappable
                  onTap: () {
                    if (!isVaccinated) {
                      // Show a dialog prompting to confirm vaccinations
                      DialogInfo(
                        headerText: 'Vaccination Confirmation',
                        subText: 'Has your pet received all the necessary vaccinations?',
                        confirmText: 'Confirm',
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                        onConfirm: () async {
                          // Show loading dialog
                          DialogLoading(subtext: "Processing...").build(context);
                          try {
                            // Attempt to update vaccination status
                            await updateVaccinationStatus(petId!, true);

                            // Close the loading dialog
                            Navigator.of(context).pop(); // Close loading dialog

                            // Close the confirmation dialog
                            Navigator.of(context).pop(); // Close confirmation dialog

                            // Show success dialog
                            DialogInfo(
                              headerText: 'Success',
                              subText: 'Vaccination status updated successfully.',
                              confirmText: 'OK',
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                              onConfirm: () {
                                Navigator.of(context).pop();
                              },
                            ).build(context);
                          } catch (e) {
                            // Close loading dialog if there's an error
                            Navigator.of(context).pop(); // Close loading dialog

                            // Close the confirmation dialog if it's still open
                            Navigator.of(context).pop(); // Close confirmation dialog

                            // Show error dialog
                            DialogInfo(
                              headerText: 'Error',
                              subText: 'Failed to update the vaccination status. Please try again.',
                              confirmText: 'OK',
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                              onConfirm: () {
                                Navigator.of(context).pop();
                              },
                            ).build(context);
                          }
                        },
                      ).build(context);
                    } else if (snapshot.data == null) {
                      // Show error message if no vaccination data is found
                      DialogInfo(
                        headerText: 'Error',
                        subText: 'Your pet has not received all the necessary vaccinations.',
                        confirmText: 'OK',
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                        onConfirm: () {
                          Navigator.of(context).pop();
                        },
                      ).build(context);
                    } else if (isVaccinated) {
                      // Show a confirmation dialog that the pet is already vaccinated
                      DialogInfo(
                        headerText: 'Vaccinated',
                        subText: 'Your pet has received all the necessary vaccinations.',
                        confirmText: 'OK',
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                        onConfirm: () {
                          Navigator.of(context).pop();
                        },
                      ).build(context);
                    }
                  },
                );
              }
            },
          ),
            const SizedBox(height: 20),
            const MedicalCard(title: 'Medical History'),
          ],
        ),
      ),
    );
  }
}
