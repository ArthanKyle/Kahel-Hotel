import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

VoucherModel voucherModelFromJson(String str) => VoucherModel.fromJson(json.decode(str));
String voucherModelToJson(VoucherModel data) => json.encode(data.toJson());

class VoucherModel {
  String code;
  bool redeemed;
  String? redeemedBy;
  DateTime? redeemedAt;
  double discountValue; // Use this for a fixed amount discount
  double? discountPercentage; // Use this for percentage discount (if applicable)

  VoucherModel({
    required this.code,
    required this.redeemed,
    this.redeemedBy,
    this.redeemedAt,
    required this.discountValue,
    this.discountPercentage,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      code: json["code"] ?? '',
      redeemed: json["redeemed"] ?? false,
      redeemedBy: json["redeemedBy"],
      redeemedAt: json["redeemedAt"] != null
          ? (json["redeemedAt"] as Timestamp).toDate()
          : null,
      discountValue: (json["discountValue"] ?? 0).toDouble(), // Read fixed discount value
      discountPercentage: json["discountPercentage"] != null
          ? (json["discountPercentage"] as num).toDouble()
          : null, // Read percentage discount
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "redeemed": redeemed,
    "redeemedBy": redeemedBy,
    "redeemedAt": redeemedAt != null ? Timestamp.fromDate(redeemedAt!) : null,
    "discountValue": discountValue, // Add fixed discount value to JSON
    "discountPercentage": discountPercentage, // Add percentage discount to JSON
  };

  factory VoucherModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return VoucherModel(
      code: data['code'] ?? '',
      redeemed: data['redeemed'] ?? false,
      redeemedBy: data['redeemedBy'],
      redeemedAt: data['redeemedAt'] != null
          ? (data['redeemedAt'] as Timestamp).toDate()
          : null,
      discountValue: (data['discountValue'] ?? 0).toDouble(), // Read fixed discount value from snapshot
      discountPercentage: data['discountPercentage'] != null
          ? (data['discountPercentage'] as num).toDouble()
          : null, // Read percentage discount from snapshot
    );
  }
}
