import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahel/api/user_service.dart';
import '../models/voucher.dart';

class VoucherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService userService = UserService(); // Create instance of UserService

  Future<bool> redeemVoucher(String code, String userId) async {
    try {
      // Fetch the voucher with the given code
      QuerySnapshot query = await _firestore
          .collection('vouchers')
          .where('code', isEqualTo: code)
          .where('redeemed', isEqualTo: false)
          .get();

      if (query.docs.isNotEmpty) {
        DocumentSnapshot doc = query.docs.first;

        // Deduct pawKoin before redeeming
        bool deducted = await userService.deductPawKoin(userId, 50.0); // Deduct 50.0 pawKoin
        if (!deducted) {
          return false; // Not enough pawKoin to redeem the voucher
        }

        // Update the voucher to mark it as redeemed
        await _firestore.collection('vouchers').doc(doc.id).update({
          'redeemed': true,
          'redeemedBy': userId,
          'redeemedAt': FieldValue.serverTimestamp(), // Use server timestamp
        });
        return true; // Redemption successful
      }
      return false; // Voucher not found or already redeemed
    } catch (e) {
      print("Error redeeming voucher: $e");
      return false; // Handle error
    }
  }
}
