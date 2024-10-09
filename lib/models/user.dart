import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahel/models/transactions.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String name;
  String email;
  String mpin;
  String birthday;
  String phoneNumber;
  String balance;
  String salt;
  double pawKoins;
  String transactionCount;
  String lastTransactionDate;
  List<String> claimedDays;
  String walletAddress;

  UserModel({
    required this.name,
    required this.email,
    required this.mpin,
    required this.birthday,
    required this.phoneNumber,
    required this.balance,
    required this.salt,
    required this.pawKoins,
    required this.transactionCount,
    required this.lastTransactionDate,
    required this.claimedDays,
    required this.walletAddress,
  });

  // Factory method to create UserModel from Firestore JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      mpin: json["mpin"] ?? '',
      birthday: json["birthday"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      balance: json["balance"] ?? '0',
      salt: json["salt"] ?? '',
      pawKoins: (json["pawKoins"] ?? 0).toDouble(),  // Safe casting to double
      transactionCount: json["transactionCount"] ?? '0',
      lastTransactionDate: json["lastTransactionDate"] ?? '',
      claimedDays: List<String>.from(json["claimedDays"] ?? []),  // Safe casting to List<String>
      walletAddress: json["walletAddress"] ?? '',
    );
  }

  // Convert the UserModel to JSON format for Firestore
  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "mpin": mpin,
    "birthday": birthday,
    "phoneNumber": phoneNumber,
    "balance": balance,
    "salt": salt,
    "pawKoins": pawKoins,
    "transactionCount": transactionCount,
    "lastTransactionDate": lastTransactionDate,
    "claimedDays": claimedDays,
    "walletAddress": walletAddress,
  };

  // Factory method to create UserModel from Firestore DocumentSnapshot
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      mpin: data['mpin'] ?? '',
      birthday: data['birthday'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      balance: data['balance'] ?? '0',
      salt: data['salt'] ?? '',
      pawKoins: data['pawKoins'] != null ? (data['pawKoins'] as num).toDouble() : 0,
      transactionCount: data['transactionCount'] ?? '0',
      lastTransactionDate: data['lastTransactionDate'] ?? '',
      claimedDays: data['claimedDays'] != null ? List<String>.from(data['claimedDays']) : [],
      walletAddress: data['walletAddress'] ?? '',
    );
  }

  void updatePawKoinsFromTransaction(TransactionModel transaction, double conversionRate) {
    pawKoins += transaction.convertPointsToPawKoins(conversionRate);
  }
}
