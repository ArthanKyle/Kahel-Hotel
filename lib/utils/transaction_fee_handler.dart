import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/user.dart';


Future<void> transactionFeeHandler({required String uid}) async {
  try {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    UserModel user = UserModel.fromSnapshot(doc);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM dd').format(now);

    if (formattedDate != user.lastTransactionDate) {
      await transactionCountReset(uid: uid, userData: user, now: formattedDate);
    }
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }

    throw "Error: ${err.toString()}";
  }
}

Future<void> transactionCountReset({
  required String uid,
  required UserModel userData,
  required String now,
}) async {
  try {
    UserModel user = userData;
    user.transactionCount = "0";

    await FirebaseFirestore.instance.collection("users").doc(uid).set(
          user.toJson(),
        );
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }

    throw "Error: ${err.toString()}";
  }
}

Future<void> updateTransactionDate(
    {required UserModel userData, required String uid}) async {
  try {
    UserModel user = userData;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM dd').format(now);

    user.lastTransactionDate = formattedDate;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(user.toJson());
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }

    throw "Error: ${err.toString()}";
  }
}

Future<void> updateTransactionCount({
  required UserModel userData,
  required String uid,
}) async {
  try {
    UserModel user = userData;

    // Check if the current transaction count is less than 6
    if (user.transactionCount == '6') {
      debugPrint('Transaction count has reached the limit of 6. No update required.');
      return; // No need to update if count is already at limit
    }

    // Safely increment the transaction count
    int count = int.tryParse(user.transactionCount) ?? 0; // Safely parse or default to 0
    debugPrint('Current transaction count: $count');

    // Increment count if it's less than 6
    if (count < 6) {
      count++; // Increment the count
      user.transactionCount = count.toString(); // Convert back to string
      debugPrint('Updated transaction count: ${user.transactionCount}');
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({
        "transactionCount": user.transactionCount,
      });
    }
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }
    // Log unexpected errors
    debugPrint("Unexpected error: ${err.toString()}");
    throw "Error: ${err.toString()}";
  }
}


Future<String> fetchTransactionFee({required String uid}) async {
  try {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    UserModel user = UserModel.fromSnapshot(doc);

    String transactionFee =
        transactionCountConversion(count: user.transactionCount);

    return transactionFee;
  } catch (err) {
    return "0";
  }
}

String transactionCountConversion({required String count}) {
  String fee = (5 * int.parse(count)).toString();
  return fee;
}

String generateRandomCode(int length) {
  const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => charset.codeUnitAt(random.nextInt(charset.length)),
    ),
  );
}

String formatName(String name) {
  if (name.length <= 5) {
    return name;
  } else {
    String firstThree = name.substring(0, 3);
    String lastTwo = name.substring(name.length - 2);
    String hashedChars = "*" * (name.length - 5);
    return '$firstThree$hashedChars$lastTwo';
  }
}
