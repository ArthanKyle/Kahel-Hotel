import 'package:flutter/material.dart';

class BookingDetailsProvider with ChangeNotifier {
  String fromDate = '';
  String toDate = '';
  String notes = '';
  String petName = '';
  String selectedPackage = '';
  double selectedPrice = 0.0;
  String checkInTime = ''; // Added check-in time
  String checkOutTime = ''; // Added check-out time

  // Method to update booking details
  void updateBookingDetails({
    required String fromDate,
    required String toDate,
    required String notes,
    required String petName,
    required String selectedPackage,
    required double selectedPrice,
    required String checkInTime, // Added parameter
    required String checkOutTime, // Added parameter
  }) {
    this.fromDate = fromDate;
    this.toDate = toDate;
    this.notes = notes;
    this.petName = petName;
    this.selectedPackage = selectedPackage;
    this.selectedPrice = selectedPrice;
    this.checkInTime = checkInTime; // Update check-in time
    this.checkOutTime = checkOutTime; // Update check-out time

    notifyListeners(); // Notify any listeners that the data has changed
  }
}
