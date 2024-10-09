import 'package:flutter/material.dart';

class SharedData {
  static final SharedData _instance = SharedData._internal();

  String? petName;
  DateTime? fromDate;
  DateTime? toDate;
  String? notes;
  String? selectedPackage;
  double? packagePrice;

  TimeOfDay? _fromTime;  // Private property
  TimeOfDay? _toTime;    // Private property

  TimeOfDay? get fromTime => _fromTime; // Getter for fromTime
  TimeOfDay? get toTime => _toTime;     // Getter for toTime

  set fromTime(TimeOfDay? value) {
    _fromTime = value; // Setter for fromTime
  }

  set toTime(TimeOfDay? value) {
    _toTime = value; // Setter for toTime
  }

  factory SharedData() {
    return _instance;
  }

  SharedData._internal();
}
