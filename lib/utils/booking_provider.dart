import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import the intl package

class BookingDetailsProvider with ChangeNotifier {
  String fromDate = '';
  String toDate = '';
  String petName = '';
  String selectedPackage = '';
  double selectedPrice = 0.0;


  // Method to update booking details
  void updateBookingDetails({
    required String fromDate,
    required String toDate,
    required String petName,
    required String selectedPackage,
    required double selectedPrice,
    required String checkInTime, // Added parameter
    required String checkOutTime, // Added parameter
  }) {
    // Validate the date format before assigning
    if (fromDate.isEmpty || toDate.isEmpty) {
      throw Exception('Both fromDate and toDate must be provided.');
    }

    // Example date format validation
    try {
      DateFormat('yyyy-MM-dd hh:mm a').parseStrict(fromDate);
      DateFormat('yyyy-MM-dd hh:mm a').parseStrict(toDate);
    } catch (e) {
      throw Exception('Invalid date format. Please use yyyy-MM-dd hh:mm a.');
    }

    this.fromDate = fromDate;
    this.toDate = toDate;
    this.petName = petName;
    this.selectedPackage = selectedPackage;
    this.selectedPrice = selectedPrice;


    notifyListeners(); // Notify any listeners that the data has changed
  }
}
