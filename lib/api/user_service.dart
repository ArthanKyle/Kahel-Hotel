import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> deductPawKoin(String userId, double amount) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      return await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);
        double currentPawKoin = snapshot['pawKoin']; // Assuming pawKoin is stored as a double

        if (currentPawKoin >= amount) {
          transaction.update(userRef, {'pawKoin': currentPawKoin - amount});
          return true; // Successful deduction
        } else {
          return false; // Not enough pawKoin
        }
      });
    } catch (e) {
      print("Error deducting pawKoin: $e");
      return false; // Handle error and return false
    }
  }
}
