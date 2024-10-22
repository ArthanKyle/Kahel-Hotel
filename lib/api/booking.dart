import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:kahel/api/transactions.dart';
import '../models/bookingModel.dart';
import '../models/transactions.dart';
import '../models/user.dart';
import '../utils/transaction_fee_handler.dart';
import '../widgets/landing/cards/payment_card.dart';


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
      print("Fetching bookings for user: $uid"); // Debug log
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('uid', isEqualTo: uid)
          .get();

      print("Bookings fetched: ${snapshot.docs.length}"); // Debug log

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

Future<TransactionModel> createBooking({
  required String uid,
  required String petName,
  required DateTime fromDate,
  required DateTime toDate,
  required String package,
  required String price,
  required String paymentMethod,
  required BookingModel data,
  required double pointsEarned,
}) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    // Fetch user data
    DocumentSnapshot userSnapshot = await db.collection('users').doc(uid).get();
    UserModel user = UserModel.fromSnapshot(userSnapshot);

    double userBalance = double.parse(user.balance);
    double parsedPrice = double.parse(price.replaceAll(',', '').trim());
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM dd yyyy').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);
    String transactionId = generateRandomCode(12);
    double pointsEarned = parsedPrice * 0.002; // Adjusted to use double

    // Check if the user has enough balance
    if (userBalance >= parsedPrice) {
      // Update the user's balance
      double newBalance = userBalance - parsedPrice;
      await db.collection('users').doc(uid).update({
        'balance': newBalance.toStringAsFixed(2),
      });

      // Create the transaction model for the booking
      TransactionModel transaction = TransactionModel(
        uid: uid,
        createdAt: '$formattedDate $formattedTime',
        amount: price,
        amountType: "decrease",
        transactionId: transactionId,
        type: "Booking",
        recipient: "Booking for $petName",
        desc: "You've successfully booked $package for $petName",
        time: formattedTime,
        pointsEarned: pointsEarned, // Ensure points are stored as a string
        senderLeftHeadText: "Transfer from",
        senderLeftSubText: paymentMethod,
        senderRightHeadText: user.name,
        senderRightSubText: petName,
        recipientLeftHeadText: "To",
        recipientLeftSubText: "Kahel's PAWsitive Walks",
        recipientRightHeadText: "Package",
        recipientRightSubText: package,
        transactionFee: '10.00', // Assuming a fixed fee, adjust if necessary
      );

      // Optionally save the transaction to Firestore
      await apiSetTransactions(transaction: transaction);

      return transaction; // Return the created transaction
    } else {
      throw "Insufficient balance to complete the booking.";
    }
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }
    throw "Error: ${err.toString()}";
  }
}
