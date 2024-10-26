import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahel/widgets/landing/cards/medical_card.dart';
import 'package:kahel/widgets/universal/dialog_info.dart';
import 'package:kahel/widgets/universal/dialog_loading.dart';
import '../../api/auth.dart';
import '../../api/pet.dart';
import '../../constants/colors.dart';
import '../../models/pet.dart';
import '../../utils/index_provider.dart';
import '../../widgets/landing/cards/info_card.dart';
import '../../widgets/landing/cards/pet_details.dart';
import '../../widgets/notifications/notificaton_modal.dart';
import '../../widgets/universal/auth/add.dart';
import '../../widgets/universal/auth/arrow_back.dart';

class PetProfilePage extends StatefulWidget {
  const PetProfilePage({super.key});

  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  List<PetModel> pets = [];
  User? user;
  int currentIndex = 0;

  @override
  void initState() {
    user = getUser();
    super.initState();
    _loadPetData();
  }

  Future<void> _loadPetData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot petsSnapshot = await FirebaseFirestore.instance
          .collection('pets')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (petsSnapshot.docs.isNotEmpty) {
        setState(() {
          pets = petsSnapshot.docs.map((doc) {
            return PetModel.fromSnapshot(doc); // Use fromSnapshot method
          }).toList();
        });
      }
    }
  }

  Stream<bool> getPetVaccinationStatus(String petId) {
    return FirebaseFirestore.instance
        .collection('pets')
        .doc(petId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        throw Exception("No vaccination data available");
      }
      return snapshot.get('isVaccinated') ?? false;
    });
  }

  void _updateVaccinationStatus(String petId, bool isVaccinated) async {
    await updateVaccinationStatus(petId, isVaccinated);
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Add(
                        onTap: () {
                          changePage(index: 7, context: context);
                        },
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () => NotifModal(uid: user!.uid).build(context),
                        child: Image.asset(
                          'assets/images/icons/bell.png',
                          height: 28,
                          width: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 290,
              child: PageView.builder(
                itemCount: pets.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  PetModel pet = pets[index];
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
                },
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<bool>(
              stream: getPetVaccinationStatus(pets[currentIndex].petId), // Use petId
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
                    isClickable: true,
                    onTap: () {
                      if (!isVaccinated) {
                        DialogInfo(
                          headerText: 'Vaccination Confirmation',
                          subText: 'Has ${pets[currentIndex].petName} received all necessary vaccinations?',
                          confirmText: 'Confirm',
                          onCancel: () {
                            Navigator.of(context).pop();
                          },
                          onConfirm: () async {
                            DialogLoading(subtext: "Processing...").build(context);
                            try {
                              _updateVaccinationStatus(pets[currentIndex].petId, true); // Use petId
                              Navigator.of(context).pop(); // Close loading dialog
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
                              Navigator.of(context).pop(); // Close loading dialog
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
                      } else {
                        DialogInfo(
                          headerText: 'Vaccinated',
                          subText: '${pets[currentIndex].petName} has received all necessary vaccinations.',
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
            MedicalCard(
              title: 'View Activity',
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
