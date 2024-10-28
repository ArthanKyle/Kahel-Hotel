import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> deductPawKoin(String userId, double amount) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      DocumentSnapshot snapshot = await userRef.get();

      // Check if the user document exists
      if (!snapshot.exists) {
        print("User document does not exist for userId: $userId");
        return false; // User does not exist
      }

      // Cast the data to a Map<String, dynamic>
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      // Ensure 'pawKoins' exists and has a default value of 0 if not present
      double currentBalance = (userData['pawKoins'] ?? 0).toDouble();

      if (currentBalance >= amount) {
        await userRef.update({
          'pawKoins': currentBalance - amount,
        });
        return true; // Deduction was successful
      } else {
        print("Not enough pawKoins to deduct. Current balance: $currentBalance, Amount to deduct: $amount");
        return false; // Not enough balance
      }
    } catch (e) {
      print("Error deducting pawKoin: $e");
      return false; // Handle error
    }
  }

  Future<bool> redeemVoucher(String userId, String userName, String voucherCode, double discountValue) async {
    try {
      // Prepare the redemption data
      Map<String, dynamic> redemptionData = {
        'voucherCode': voucherCode,
        'redeemedBy': userName,
        'userId': userId,
        'redeemedAt': FieldValue.serverTimestamp(),
        'discountValue': discountValue, // Include the discount value in the redemption record
      };

      // Add the redemption record to the 'redemptions' collection
      DocumentReference redemptionRef = _firestore.collection('redemptions').doc(); // Automatically generates a new ID
      await redemptionRef.set(redemptionData);

      print("Voucher redeemed and recorded successfully: $voucherCode");
      return true; // Redemption was successful
    } catch (e) {
      print("Error redeeming voucher: $e");
      return false; // Handle error
    }
  }

}
