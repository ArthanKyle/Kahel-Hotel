import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String uid;
  String petName;
  DateTime fromDate;
  DateTime toDate;
  String notes;
  String package;
  String price;
  String transactionId;
  String paymentMethod; // New field

  // Constructor
  BookingModel({
    required this.uid,
    required this.petName,
    required this.fromDate,
    required this.toDate,
    required this.notes,
    required this.package,
    required this.price,
    required this.transactionId,
    required this.paymentMethod, // Add payment method to constructor
  });

  // Convert BookingModel to JSON string
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'petName': petName,
    'fromDate': fromDate.toIso8601String(),
    'toDate': toDate.toIso8601String(),
    'notes': notes,
    'package': package,
    'price': price,
    'transactionId': transactionId,
    'paymentMethod': paymentMethod, // Add payment method to JSON
  };

  // Create BookingModel from Firestore DocumentSnapshot
  factory BookingModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>? ?? {};
    return BookingModel(
      uid: data['uid'] ?? '',
      petName: data['petName'] ?? '',
      fromDate: data['fromDate'] != null ? DateTime.parse(data['fromDate']) : DateTime.now(),
      toDate: data['toDate'] != null ? DateTime.parse(data['toDate']) : DateTime.now(),
      notes: data['notes'] ?? '',
      package: data['package'] ?? '',
      price: data['price']?.toString() ?? '0',
      transactionId: data['transactionId'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '', // Add payment method retrieval
    );
  }

  // Create BookingModel from JSON map
  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    uid: json["uid"] ?? '',
    petName: json["petName"] ?? '',
    fromDate: json["fromDate"] != null ? DateTime.parse(json["fromDate"]) : DateTime.now(),
    toDate: json["toDate"] != null ? DateTime.parse(json["toDate"]) : DateTime.now(),
    notes: json["notes"] ?? '',
    package: json["package"] ?? '',
    price: json["price"]?.toString() ?? '0',
    transactionId: json["transactionId"] ?? '',
    paymentMethod: json["paymentMethod"] ?? '', // Add payment method parsing
  );
}
