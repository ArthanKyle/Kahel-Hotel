import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:kahel/api/transactions.dart';
import '../models/transactions.dart';
import '../models/user.dart';
import '../models/withdraw_depo.dart';
import '../utils/transaction_fee_handler.dart';


Future<TransactionModel> deposit(
    {required WithdrawAndDepositModel data}) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('users')
        .doc(data.uid)
        .get();

    UserModel userData = UserModel.fromSnapshot(user);

    double currentBalance =
        double.parse(userData.balance) - double.parse(data.amount);

    userData.balance = currentBalance.toString();

    await db.collection("users").doc(data.uid).set(userData.toJson());

    await updateTransactionDate(userData: userData, uid: data.uid);
    await updateTransactionCount(userData: userData, uid: data.uid);

    DateTime now = DateTime.now();

    String formattedDate = DateFormat('MMM dd yyyy').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);

    String transactionId = generateRandomCode(12);

    TransactionModel userTransaction = TransactionModel(
      transactionId: transactionId,
      uid: data.uid,
      createdAt: formattedDate,
      amount: data.totalAmount,
      amountType: "decrease",
      type: data.typeReceipt,
      recipient: data.bank,
      note: "",
      desc: "You've successfully transferred money to ${data.bank}",
      transactionFee: data.transactionFee,
      time: formattedTime,
      pointsEarned: 0.2 * double.parse(data.transactionFee),
      senderLeftHeadText: "From",
      senderLeftSubText: "Bank",
      senderRightHeadText: data.bank,
      senderRightSubText: data.accountNumber,
      recipientLeftHeadText: "To",
      recipientLeftSubText: "UPay",
      recipientRightHeadText: data.name,
      recipientRightSubText: "Deposit",
    );

    await apiSetTransactions(transaction: userTransaction);

    return userTransaction;
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }

    throw "Error: ${err.toString()}";
  }
}
