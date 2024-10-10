import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:kahel/api/transactions.dart';
import '../models/top_up_model.dart';
import '../models/transactions.dart';
import '../models/user.dart';
import '../utils/transaction_fee_handler.dart';
import '../widgets/landing/cards/payment_card.dart';

Future<TransactionModel> topUp({
  required TopUpModel data,
  required String userUid,
  required double pointsEarned,
}) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    // Fetch the user's data
    DocumentSnapshot userSnapshot = await db.collection('users').doc(userUid).get();
    UserModel sender = UserModel.fromSnapshot(userSnapshot); // Use sender here

    // Ensure balance is valid before parsing
    double userBalance = 0.0;
    if (sender.balance.isNotEmpty) {
      userBalance = double.parse(sender.balance);
    } else {
      throw "User balance is empty or invalid.";
    }

    // Ensure moneyToSend is valid before parsing
    double moneyToSend = 0.0;
    if (data.moneyToSend.isNotEmpty) {
      moneyToSend = double.parse(data.moneyToSend);
    } else {
      throw "Money to send is empty or invalid.";
    }

    // Update balance
    sender.balance = (userBalance + moneyToSend).toString();

    // Update user's pawKoins and balance in Firestore
    sender.pawKoins += pointsEarned;
    await db.collection("users").doc(userUid).set(sender.toJson());

    // Update the transaction date and count for the sender
    await updateTransactionDate(userData: sender, uid: userUid);
    await updateTransactionCount(userData: sender, uid: userUid);

    // Create a transaction record
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM dd yyyy').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);
    String transactionId = generateRandomCode(12);

    TransactionModel transaction = TransactionModel(
      transactionId: transactionId,
      uid: userUid,
      createdAt: formattedDate + ' ' + formattedTime,
      amount: data.moneyToSend,
      amountType: "increase",
      type: "Top Up",
      recipient: "Top Up Money",
      note: data.note ?? "",
      desc: "You've successfully topped up your account.",
      transactionFee: data.transactionFee,
      time: formattedTime,
      pointsEarned: pointsEarned,
      senderLeftHeadText: "From",
      senderLeftSubText: "Credit Card",
      senderRightHeadText: "KAHEL Hotel",
      senderRightSubText: "BDO Unibank Inc.",
      recipientLeftHeadText: "To",
      recipientLeftSubText:   data.selectedBank,
      recipientRightHeadText: formatName(sender.name),
      recipientRightSubText: maskAccountNumber(data.linkedAccountId),
    );

    await apiSetTransactions(transaction: transaction);

    return transaction;
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }
    throw "Error: ${err.toString()}";
  }
}

// Updated method to get bank account balance
Future<double> getBankAccountBalance(String userId) async {
  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  UserModel user = UserModel.fromSnapshot(userSnapshot);
  return double.parse(user.balance ?? '0');
}

Future<void> updateBankAccountBalance(String userId, double newBalance) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'balance': newBalance.toString(),
  });
}
