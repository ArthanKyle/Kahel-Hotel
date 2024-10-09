import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/profile_card.dart';
import '../models/user.dart';

Future<ProfileCardRes> apiProfileCard({required String uid}) async {
  try {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!documentSnapshot.exists) {
      throw Exception("User data does not exist!");
    }

    UserModel obj = UserModel.fromSnapshot(documentSnapshot);
    ProfileCardModel data =
        ProfileCardModel(name: obj.name, balance: obj.balance);
    ProfileCardRes res = ProfileCardRes(data: data);

    return res;
  } catch (err) {
    if (err is FirebaseException) {
      return ProfileCardRes(errorMessage: err.message);
    }

    return ProfileCardRes(errorMessage: err.toString());
  }
}

Future<UserModel> getUserData({required String uid}) async {
  try {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!documentSnapshot.exists) {
      throw Exception("User data does not exist!");
    }

    UserModel obj = UserModel.fromSnapshot(documentSnapshot);

    return obj;
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }

    throw "Error: ${err.toString()}";
  }
}
