import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

VoucherModel voucherModelFromJson(String str) => VoucherModel.fromJson(json.decode(str));
String voucherModelToJson(VoucherModel data) => json.encode(data.toJson());

class VoucherModel {
  String code;
  bool redeemed;
  String? redeemedBy;
  DateTime? redeemedAt;

  VoucherModel({
    required this.code,
    required this.redeemed,
    this.redeemedBy,
    this.redeemedAt,
  });


  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      code: json["code"] ?? '',
      redeemed: json["redeemed"] ?? false,
      redeemedBy: json["redeemedBy"],
      redeemedAt: json["redeemedAt"] != null
          ? (json["redeemedAt"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "redeemed": redeemed,
    "redeemedBy": redeemedBy,
    "redeemedAt": redeemedAt != null ? Timestamp.fromDate(redeemedAt!) : null,
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
    );
  }
}
