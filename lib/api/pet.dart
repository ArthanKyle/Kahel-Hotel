import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/pet.dart';
import 'package:firebase_storage/firebase_storage.dart';


Future<List<PetModel>> getPetData({required String uid}) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('pets')
        .where('uid', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("No pets found for this user!");
    }

    List<PetModel> pets = querySnapshot.docs.map((doc) {
      // Extract petId from the document ID
      return PetModel.fromSnapshot(doc).copyWith(petId: doc.id);
    }).toList();

    return pets;
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }
    throw "Error: ${err.toString()}";
  }
}


Stream<double> getPetWalkProgress({required String uid}) {
  try {
    return FirebaseFirestore.instance
        .collection('pets')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        return 0.0; // No pets found
      }

      // Assume there's only one pet per UID, otherwise adjust to handle multiple pets
      DocumentSnapshot doc = querySnapshot.docs.first;
      PetModel pet = PetModel.fromSnapshot(doc).copyWith(petId: doc.id);

      // Convert walk field to double, assuming it's a string in Firestore
      return double.tryParse(pet.walk) ?? 0.0;
    });
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }
    throw "Error: ${err.toString()}";
  }
}



Future<void> createPet({
  required String petId,
  required String uid,
  required String petName,
  required String petBreed,
  required String gender,
  required String birthday,
  required String weight,
  required String preferences,
  required String allergies,
  required String walk,
  required bool isVaccinated,
  String? profilePictureUrl,
}) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  try {
    PetModel pet = PetModel(
      petId: petId,
      petName: petName,
      petBreed: petBreed,
      gender: gender,
      birthday: birthday,
      weight: weight,
      preferences: preferences,
      allergies: allergies,
      walk: walk,
      isVaccinated: isVaccinated,
      uid: uid,
      profilePictureUrl: profilePictureUrl ?? '',
    );

    await db.collection("pets").add(pet.toJson());
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }
    throw "Error: ${err.toString()}";
  }
}

Future<bool?> checkIfMoreThanFivePets({required String uid}) async {
  try {
    // Replace with your Firestore instance and collection path
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('pets').where('uid', isEqualTo: uid).get();

    // Count the number of documents
    int count = querySnapshot.size;

    debugPrint(count.toString());

    return count > 5;
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }

    throw "Error: ${err.toString()}";
  }
}

Future<void> updateVaccinationStatus(String petId, bool isVaccinated) async {
  try {
    // Update the vaccination status in Firestore
    await FirebaseFirestore.instance
        .collection('pets')
        .doc(petId)
        .update({'isVaccinated': isVaccinated}); // Field and value to update
  } catch (e) {
    // Handle error if update fails
    print('Error updating vaccination status: $e');
    throw Exception('Failed to update vaccination status');
  }
}

