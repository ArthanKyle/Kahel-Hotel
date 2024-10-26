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



Stream<double> getPetWalkProgress({required String uid, required String petId}) {
  try {
    // Listen to the specific pet's document based on petId
    return FirebaseFirestore.instance
        .collection('pets')
        .doc(petId)  // Fetch the document for the specific pet
        .snapshots()
        .map((docSnapshot) {
      if (!docSnapshot.exists) {
        return 0.0; // Return 0.0 if the pet document doesn't exist
      }
      PetModel pet = PetModel.fromSnapshot(docSnapshot);
      return double.tryParse(pet.walk) ?? 0.0; // Default to 0.0 if parsing fails
    });
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}"; // Handle Firebase specific errors
    }
    throw "Error: ${err.toString()}"; // Handle other errors
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
    await FirebaseFirestore.instance
        .collection('pets')
        .doc(petId)
        .update({'isVaccinated': isVaccinated});
  } catch (e) {
    // Handle error if update fails
    print('Error updating vaccination status: $e');
    throw Exception('Failed to update vaccination status');
  }
}

