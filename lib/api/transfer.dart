import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:kahel/api/transactions.dart';
import '../models/transactions.dart';
import '../models/transfer_money_model.dart';
import '../models/user.dart';
import '../utils/transaction_fee_handler.dart';
import '../widgets/landing/cards/payment_card.dart';

Future<TransactionModel> transferMoney({
  required TransferMoneyModel transferData,
  required String userUid,
}) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    // Fetch sender information from 'users' collection
    DocumentSnapshot senderSnapshot = await db.collection('users').doc(transferData.senderUid).get();
    if (!senderSnapshot.exists || senderSnapshot.data() == null) {
      throw "Sender not found or data is null.";
    }
    UserModel sender = UserModel.fromSnapshot(senderSnapshot);

    // Fetch the recipient's linked account document using their UID directly
    print('Recipient UID: ${transferData.recipientUid}'); // Debug log

    // Fetch the linked account document for the recipient
    DocumentSnapshot linkedAccountDoc = await db
        .collection('linked_accounts')
        .doc(transferData.recipientUid) // Use the recipient's UID directly
        .get();

    if (!linkedAccountDoc.exists || linkedAccountDoc.data() == null) {
      throw "Recipient UID not found in linked_accounts.";
    }

    // Use the data from linkedAccountDoc directly
    String recipientUid = linkedAccountDoc['uid']; // Get the UID from the linked_accounts document
    String selectedBank = linkedAccountDoc['bank'];

    // Fetch recipient information using the recipientUid from 'users' collection
    DocumentSnapshot recipientSnapshot = await db.collection('users').doc(recipientUid).get();
    if (!recipientSnapshot.exists || recipientSnapshot.data() == null) {
      throw "Recipient not found or data is null.";
    }
    UserModel recipient = UserModel.fromSnapshot(recipientSnapshot);

    // Validate sender's balance
    double senderBalance = double.parse(sender.balance);
    double amountToSend = double.parse(transferData.amountToSend); // Ensure amountToSend is parsed as double
    if (senderBalance < amountToSend) {
      throw "Insufficient balance.";
    }

    // Deduct transaction fee
    double transactionFee = 10.0; // Fixed fee, or you can calculate dynamically
    double totalDeduction = amountToSend + transactionFee;

    // Update sender's balance
    sender.balance = (senderBalance - totalDeduction).toString();
    await db.collection('users').doc(transferData.senderUid).set(sender.toJson());

    // Update recipient's balance
    double recipientBalance = double.parse(recipient.balance);
    recipient.balance = (recipientBalance + amountToSend).toString();
    await db.collection('users').doc(recipientUid).set(recipient.toJson());

    // Add points to the sender
    sender.pawKoins += transferData.pointsEarned;
    await db.collection("users").doc(transferData.senderUid).set(sender.toJson());

    // Create a transaction record
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM dd yyyy').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);
    String transactionId = generateRandomCode(12);

    TransactionModel transaction = TransactionModel(
      transactionId: transactionId,
      uid: transferData.senderUid,
      createdAt: formattedDate,
      amount: amountToSend.toString(),
      amountType: "decrease",
      type: "Transfer",
      recipient: "Transfer Money",
      note: transferData.note ?? "",
      desc: "You've successfully transferred money. ",
      transactionFee: transactionFee.toString(),
      time: formattedTime,
      senderLeftHeadText: "From",
      senderLeftSubText: "Balance",
      senderRightHeadText: sender.name,
      senderRightSubText: maskPhoneNumber(sender.phoneNumber),
      recipientLeftHeadText: "To",
      recipientLeftSubText: selectedBank,
      recipientRightHeadText: recipient.name,
      recipientRightSubText: maskAccountNumber(transferData.linkedBankId),
      pointsEarned: transferData.pointsEarned,
    );

    // Save the transaction
    await updateTransactionDate(userData: sender, uid: userUid);
    await updateTransactionCount(userData: sender, uid: userUid);
    await apiSetTransactions(transaction: transaction);

    return transaction;
  } catch (err) {
    if (err is FirebaseException) {
      throw "Error: ${err.message}";
    }
    throw "Error: ${err.toString()}";
  }
}
