import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

TransferMoneyModel transferMoneyModelFromJson(String str) =>
    TransferMoneyModel.fromJson(json.decode(str));

String transferMoneyModelToJson(TransferMoneyModel data) =>
    json.encode(data.toJson());

class TransferMoneyModel {
  String senderUid;
  String userUid;
  String recipientUid;
  String linkedBankId;
  String amountToSend;
  String transactionFee;
  String totalExpenses;
  double pointsEarned;
  String? note;
  String selectedBank;

  TransferMoneyModel({
    required this.senderUid,
    required this.userUid,
    required this.recipientUid,
    required this.linkedBankId,
    required this.amountToSend,
    required this.transactionFee,
    required this.totalExpenses,
    required this.pointsEarned,
    required this.selectedBank,
    this.note,
  });

  // Factory constructor to create an instance of TransferMoneyModel from JSON
  factory TransferMoneyModel.fromJson(Map<String, dynamic> json) =>
      TransferMoneyModel(
        senderUid: json["senderUid"],
        userUid: json["userUid"],
        recipientUid: json["recipientUid"],
        linkedBankId: json["linkedBankId"],
        amountToSend: json["amountToSend"],
        transactionFee: json["transactionFee"],
        totalExpenses: json["totalExpenses"],
        pointsEarned: json["pointsEarned"].toDouble(),
        note: json["note"] ?? "",
        selectedBank: json["selectedBank"],
      );
  // Add this method to create an instance from Firestore snapshot
  factory TransferMoneyModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return TransferMoneyModel(
      senderUid: data['senderUid'],
      userUid: data['userUid'],
      recipientUid: data['recipientUid'],
      linkedBankId: data['linkedBankId'],
      amountToSend: data['amountToSend'],
      pointsEarned: data['pointsEarned'],
      transactionFee: data['transactionFee'],
      totalExpenses: data['totalExpenses'],
      note: data['note'],
      selectedBank: data['selectedBank'],

    );
  }

  Map<String, dynamic> toJson() => {
    "senderUid": senderUid,
    "userUid": userUid,
    "recipientUid": recipientUid,
    "linkedBankId": linkedBankId,
    "amountToSend": amountToSend,
    "transactionFee": transactionFee,
    "totalExpenses": totalExpenses,
    "pointsEarned": pointsEarned,
    "note": note,
    "selectedBank": selectedBank,
  };
}
