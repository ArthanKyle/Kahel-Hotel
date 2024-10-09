import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bookingModel.dart';
import '../models/transactions.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBooking(BookingModel booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toJson());
    } catch (e) {
      print('Error creating booking: $e');
    }
  }

  Future<List<BookingModel>> fetchBookings(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('uid', isEqualTo: uid)
          .get();

      return snapshot.docs.map((doc) {
        return BookingModel.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }
}

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchUserPets(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('pets')
          .where('uid', isEqualTo: uid)
          .get();

      return snapshot.docs.map((doc) {
        return (doc.data() as Map<String, dynamic>)['petName'] as String;
      }).toList();
    } catch (e) {
      print('Error fetching pets: $e');
      return [];
    }
  }
}
Future<void> createBooking({
  required String uid,
  required String petName,
  required DateTime fromDate,
  required DateTime toDate,
  required String notes,
  required String package,
  required String price,
  required String transactionId,
  required String paymentMethod, // New parameter
}) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    // Format the price to 2 decimal places
    double parsedPrice = double.parse(price.toString().replaceAll(',', '').trim());
    String formattedPrice = parsedPrice.toStringAsFixed(2);

    // Create a new booking with a 'pending' payment status
    BookingModel booking = BookingModel(
      uid: uid,
      petName: petName,
      fromDate: fromDate,
      toDate: toDate,
      notes: notes,
      package: package,
      price: formattedPrice,
      transactionId: transactionId,
      paymentMethod: paymentMethod,
    );

    // Save booking to Firestore
    await db.collection("bookings").add(booking.toJson());
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }
    throw "Error: ${err.toString()}";
  }
}
