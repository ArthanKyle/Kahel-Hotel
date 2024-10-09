import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

PetModel petModelFromJson(String str) => PetModel.fromJson(json.decode(str));

String petModelToJson(PetModel data) => json.encode(data.toJson());

class PetModel {
  String petId; // New field
  String petName;
  String petBreed;
  String gender;
  String birthday;
  String weight;
  String preferences;
  String allergies;
  String walk;
  bool isVaccinated;
  String uid;
  String profilePictureUrl; // Nullable profile picture URL

  // Constructor
  PetModel({
    required this.petId, // New field
    required this.petName,
    required this.petBreed,
    required this.gender,
    required this.birthday,
    required this.weight,
    required this.preferences,
    required this.allergies,
    required this.walk,
    required this.isVaccinated,
    required this.uid,
    required this.profilePictureUrl, // Nullable so 'this' is used instead of 'required'
  });

  // toJson method
  Map<String, dynamic> toJson() => {
    'petId': petId, // New field
    'petName': petName,
    'petBreed': petBreed,
    'gender': gender,
    'birthday': birthday,
    'weight': weight,
    'preferences': preferences,
    'allergies': allergies,
    'walk': walk,
    'isVaccinated': isVaccinated,
    'uid': uid,
    'profilePictureUrl': profilePictureUrl, // Include the getter
  };
  // Create a copyWith method for PetModel
  PetModel copyWith({
    String? petId,
    String? petName,
    String? petBreed,
    String? gender,
    String? birthday,
    String? weight,
    String? preferences,
    String? allergies,
    String? walk,
    bool? isVaccinated,
    String? profilePictureUrl,
    String? uid,
  }) {
    return PetModel(
      petId: petId ?? this.petId,
      petName: petName ?? this.petName,
      petBreed: petBreed ?? this.petBreed,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      weight: weight ?? this.weight,
      preferences: preferences ?? this.preferences,
      allergies: allergies ?? this.allergies,
      walk: walk ?? this.walk,
      isVaccinated: isVaccinated ?? this.isVaccinated,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      uid: uid ?? this.uid,
    );
  }
  // fromSnapshot method
  factory PetModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>? ?? {};
    return PetModel(
      petId: snapshot.id, // Automatically assign the Firestore document ID as petId
      petName: data['petName'] ?? '',
      petBreed: data['petBreed'] ?? '',
      gender: data['gender'] ?? '',
      birthday: data['birthday'] ?? '',
      weight: data['weight'] ?? '',
      preferences: data['preferences'] ?? '',
      allergies: data['allergies'] ?? '',
      walk: data['walk'] ?? '',
      isVaccinated: data['isVaccinated'] ?? false,
      uid: data['uid'] ?? '',
      profilePictureUrl: data['profilePictureUrl'], // Retrieve profilePictureUrl
    );
  }

  // fromJson method
  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
    petId: json["petId"], // New field
    petName: json["petName"],
    petBreed: json["petBreed"],
    gender: json["gender"],
    birthday: json["birthday"],
    weight: json["weight"],
    preferences: json["preferences"],
    allergies: json["allergies"],
    walk: json["walk"],
    isVaccinated: json["isVaccinated"] ?? false,
    uid: json["uid"] ?? '',
    profilePictureUrl: json["profilePictureUrl"], // Initialize profilePictureUrl
  );
}
