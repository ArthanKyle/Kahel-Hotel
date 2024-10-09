import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kahel/api/user.dart';
import '../models/linked_accounts_model.dart';
import '../models/user.dart';

Future<void> linkbankAccount({
  required String uid,
  required String bank,
  required String accountName,
  required String accountNumber,
}) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    UserModel user = await getUserData(uid: uid);
    LinkAccountsModel obj = LinkAccountsModel(
        accountName: accountName,
        accountNumber: accountNumber,
        bank: bank,
        uid: uid,
        );

    await db.collection("linked_accounts").add(obj.toJson());
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }

    throw "Error: ${err.toString()}";
  }
}

Future<bool?> checkIfFiveLinkBankAccount(
    {required String uid, required String bank}) async {
  try {
    int count = 0;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('linked_accounts').get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    for (var document in documents) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      LinkAccountsModel obj = LinkAccountsModel.fromJson(data);

      if (obj.uid == uid && obj.bank == bank) count++;
    }

    debugPrint(count.toString());

    return count >= 5;
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }

    throw "Error: ${err.toString()}";
  }
}
