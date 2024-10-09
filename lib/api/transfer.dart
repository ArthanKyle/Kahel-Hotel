import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:kahel/api/transactions.dart';
import '../models/transactions.dart';
import '../models/user.dart';
import '../utils/transaction_fee_handler.dart';
import '../widgets/landing/cards/payment_card.dart';

Future<TransactionModel> transferMoney({
  required String senderUid,
  required String userUid,
  required String recipientUid,
  required String linkedBankId,
  required double amountToSend,
  required double pointsEarned,
  String? note,
}) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    // Fetch the sender's data
    DocumentSnapshot senderSnapshot = await db.collection('users').doc(senderUid).get();
    UserModel sender = UserModel.fromSnapshot(senderSnapshot);

    // Fetch the recipient's data
    DocumentSnapshot recipientSnapshot = await db.collection('users').doc(recipientUid).get();
    UserModel recipient = UserModel.fromSnapshot(recipientSnapshot);

    // Validate sender's balance
    double senderBalance = double.parse(sender.balance);
    if (senderBalance < amountToSend) {
      throw "Insufficient balance.";
    }

    // Deduct transaction fee
    double transactionFee = 10.0; // Fixed fee, or you can calculate dynamically
    double totalDeduction = amountToSend + transactionFee;

    // Update sender's balance
    sender.balance = (senderBalance - totalDeduction).toString();
    await db.collection('users').doc(senderUid).set(sender.toJson());

    // Update recipient's balance
    double recipientBalance = double.parse(recipient.balance);
    recipient.balance = (recipientBalance + amountToSend).toString();
    await db.collection('users').doc(recipientUid).set(recipient.toJson());

    // Add points to the sender
    sender.pawKoins += pointsEarned;
    await db.collection("users").doc(userUid).set(sender.toJson());

    // Create a transaction record
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM dd yyyy').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);
    String transactionId = generateRandomCode(12);

    TransactionModel transaction = TransactionModel(
      transactionId: transactionId,
      uid: senderUid,
      createdAt: formattedDate,
      amount: amountToSend.toString(),
      amountType: "decrease",
      type: "Transfer",
      recipient: recipient.name,
      note: note ?? "",
      desc: "Money transfer to ${recipient.name}",
      transactionFee: transactionFee.toString(),
      time: formattedTime,
      senderLeftHeadText: "From",
      senderLeftSubText: "Linked Bank Account",
      senderRightHeadText: "Transfer",
      senderRightSubText: maskAccountNumber(linkedBankId),
      recipientLeftHeadText: "To",
      recipientLeftSubText: recipient.name,
      recipientRightHeadText: "Received",
      recipientRightSubText: "Successfully",
      pointsEarned: pointsEarned,
    );

    // Save the transaction
    await apiSetTransactions(transaction: transaction);

    return transaction;
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }
    throw "Error: ${err.toString()}";
  }
}
