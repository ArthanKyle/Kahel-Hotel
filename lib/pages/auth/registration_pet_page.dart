import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahel/constants/colors.dart';
import 'package:kahel/pages/auth/success_register_pet.dart';
import 'package:kahel/widgets/registration/allergies.dart';
import 'package:kahel/widgets/registration/gender.dart';
import 'package:kahel/widgets/registration/pet_profile%20picture.dart';
import 'package:kahel/widgets/registration/preference.dart';
import '../../api/pet.dart';
import '../../utils/index_provider.dart';
import '../../utils/input_validators.dart';
import '../../widgets/registration/birth_of_date.dart';
import '../../widgets/registration/pet_breed.dart';
import '../../widgets/registration/text_field.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import '../../widgets/universal/auth/auth_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/universal/dialog_info.dart';
import '../../widgets/universal/dialog_loading.dart'; // Import dialog

class RegistrationPetPage extends StatefulWidget {
  const RegistrationPetPage({super.key});

  @override
  State<RegistrationPetPage> createState() => _RegistrationPetPageState();
}

class _RegistrationPetPageState extends State<RegistrationPetPage> {

  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController petBreedController = TextEditingController();
  final TextEditingController petGenderController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController petAllergiesController = TextEditingController();
  final TextEditingController petPreferenceController = TextEditingController();

  List<String> _selectedPreferences = [];
  List<String> _selectedAllergies = [];



bool createPasswordVisible = false;
  bool confirmPassVisible = false;
  bool? isChecked = false;

  User? user;
  String? profilePictureUrl; // Make this nullable to handle missing picture

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Get current user from Firebase Auth
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              ArrowBack(onTap: () {
                changePage(index: 6, context: context);
              },),
              const SizedBox(height: 20),
              const AuthInfo(
                headText: "Pet Registration",
                subText: "",
              ),
              const SizedBox(height: 20),
              PetProfilePicture(
                onPictureSelected: (url) {
                  setState(() {
                    profilePictureUrl = url; // Update profile picture URL when selected
                  });
                },
              ),
              const SizedBox(height: 20),
              BasicTextField(
                labelText: "Pet Name",
                controller: petNameController,
                validator: (value) => petNameValidator(value),
              ),
              PetBreedDropdown(
                labelText: "Pet Breed",
                controller: petBreedController,
              ),
              GenderDropdown(
                labelText: "Gender",
                controller: petGenderController,
              ),
              BirthOfDateField(
                labelText: "Date of Birth",
                controller: birthdayController,
              ),
              BasicTextField(
                labelText: "Weight",
                controller: weightController,
                validator: (value) => weightValidator(value),
              ),
              PreferencesDropdown(
                labelText: "Preferences",
                controller: petPreferenceController,
                selectedPreferences: _selectedPreferences,
                onPreferencesChanged: (updatedPreferences) {
                  setState(() {
                    _selectedPreferences = updatedPreferences;
                  });
                },
              ),
              AllergiesDropdown(
                labelText: "Allergies",
                controller: petAllergiesController,
                onAllergiesChanged: (updatedAllergies) {
                  setState(() {
                    _selectedAllergies = updatedAllergies;
                  });
                },
              ),
              const SizedBox(height: 20),
              buildSignUpButton(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignUpButton() {
    return ElevatedButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;

        DialogLoading(subtext: "Loading").build(context);

        // Ensure the pet profile picture is uploaded
        if (profilePictureUrl == null || profilePictureUrl!.isEmpty) {
          Navigator.of(context, rootNavigator: true).pop();
          DialogInfo(
            headerText: "Profile Picture Missing",
            subText: "Please upload a profile picture for your pet.",
            confirmText: "OK",
            onConfirm: () {
              Navigator.of(context, rootNavigator: true).pop();
            }, onCancel: () {
              Navigator.of(context, rootNavigator: true).pop();
          },
          ).build(context);
          return;
        }

        final petDocRef = FirebaseFirestore.instance.collection('pets').doc();
        final petId = petDocRef.id;
        // Create pet entry in the database
        await createPet(
          petId: petId,
          uid: user!.uid,
          petName: petNameController.text.trim(),
          petBreed: petBreedController.text.trim(),
          gender: petGenderController.text.trim(),
          birthday: birthdayController.text.trim(),
          weight: weightController.text.trim(),
          preferences: petPreferenceController.text.trim(),
          allergies: petAllergiesController.text.trim(),
          walk: "0", // Default or empty if not used
          isVaccinated: false,
          profilePictureUrl: profilePictureUrl!, // Pass the pet profile picture URL
        ).then(
              (value) {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessRegisterPet(
                  successMessage: " Pet ${petNameController.text.trim()} registered successfully",
                ),
              ),
            );
          },
        ).catchError((err) {
          Navigator.of(context, rootNavigator: true).pop();
          DialogInfo(
            headerText: "Error",
            subText: err.toString(),
            confirmText: "Try again",
            onCancel: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            onConfirm: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ).build(context);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.primary,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text(
        "Confirm",
        style: TextStyle(
          color: ColorPalette.accentWhite,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
