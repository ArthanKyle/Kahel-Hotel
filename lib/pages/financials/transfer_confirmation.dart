import 'package:flutter/material.dart';
import '../../api/transfer.dart';
import '../../constants/colors.dart';
import '../../models/transactions.dart';
import '../../models/transfer_money_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import '../../widgets/universal/dialog_info.dart';
import '../../widgets/universal/dialog_loading.dart';
import '../receipts/receipt_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransferConfirmation extends StatefulWidget {
  final String accountNumber;
  final String accountName;
  final String amount;
  final String notes;
  final String sendReceiptTo;
  final String recipientUid;

  const TransferConfirmation({
    Key? key,
    required this.accountNumber,
    required this.accountName,
    required this.amount,
    required this.notes,
    required this.sendReceiptTo,
    required this.recipientUid,
  }) : super(key: key);

  @override
  State<TransferConfirmation> createState() => _TransferConfirmationState();
}

class _TransferConfirmationState extends State<TransferConfirmation> {
  final _formKey = GlobalKey<FormState>();
  String selectedBank = "";

  Future<String?> fetchRecipientUid(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('linked_accounts') // Replace with your users collection name
          .where('uid', isEqualTo: uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id; // This is the recipient UID
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching recipient UID: $e');
      return null;
    }
  }

  void _showErrorDialog(String message) {
    DialogInfo(
      headerText: "Error",
      subText: message,
      confirmText: "OK",
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () => Navigator.of(context).pop(),
    ).build(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    child: ArrowBack(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Text(
                    "Transfer Confirmation",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                color: ColorPalette.primary,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "You are about to transfer",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "PHP ${widget.amount}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "CONFIRMATION",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                initialValue: widget.accountName,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Account Name",
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: ColorPalette.greyish),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorPalette.greyish),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorPalette.greyish),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: TextStyle(color: ColorPalette.greyish),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.accountNumber,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Account Number",
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: ColorPalette.greyish),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorPalette.greyish),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorPalette.greyish),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: TextStyle(color: ColorPalette.greyish),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.sendReceiptTo,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Send Receipt To",
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: ColorPalette.greyish),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorPalette.greyish),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorPalette.greyish),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: TextStyle(color: ColorPalette.greyish),
              ),
              const SizedBox(height: 45),

              // Centered Confirmation Text
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Please verify the accuracy and completeness of the details before you proceed",
                    style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                    textAlign: TextAlign.center, // Center text
                  ),
                  SizedBox(height: 8),
                  Text(
                    "By clicking 'Confirm', You hereby accept full responsibility for this transaction done with your account and MPIN",
                    style: TextStyle(fontSize: 12,fontFamily: 'Poppins', color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // Validate the form
                if (!_formKey.currentState!.validate()) return;

                FocusScope.of(context).unfocus();

                // Fetching and printing all the values from the transfer money page
                String amountToSend = widget.amount;
                String transactionFee = "10.0";
                String? notes = widget.notes.isNotEmpty ? widget.notes : null;
                String totalExpenses = (double.parse(amountToSend) + double.parse(transactionFee)).toString();
                double pointsEarned = double.parse(amountToSend) * 0.002;

                print('Account Name: ${widget.accountName}');
                print('Account Number: ${widget.accountNumber}');
                print('Amount to Send: $amountToSend');
                print('Transaction Fee: $transactionFee');
                print('Total Expenses: $totalExpenses');
                print('Send Receipt To: ${widget.sendReceiptTo}');
                print('Recipient UID: ${widget.recipientUid}');
                print('Notes: ${widget.notes}');
                print('Points Earned: $pointsEarned');

                DialogLoading(
                  subtext: "Loading...",
                  willPop: false,
                ).build(context);

                User? user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  try {
                    // Use widget.recipientUid directly since it's already provided
                    String recipientUid = widget.recipientUid;

                    // Prepare transfer data
                    TransferMoneyModel transferData = TransferMoneyModel(
                      senderUid: user.uid,
                      userUid: user.uid,
                      recipientUid: recipientUid,
                      linkedBankId: widget.accountNumber,
                      amountToSend: amountToSend,
                      pointsEarned: pointsEarned,
                      transactionFee: transactionFee,
                      totalExpenses: totalExpenses,
                      note: notes,
                      selectedBank: selectedBank,
                    );

                    // Process the transfer
                    TransactionModel transaction = await transferMoney(transferData: transferData, userUid: user.uid);

                    Navigator.pop(context); // Close loading dialog

                    // Navigate to the receipt page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptPage(
                          data: transaction,
                          onExit: () {
                            Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                          },
                        ),
                      ),
                    );
                  } catch (e, stackTrace) {
                    // Handle errors
                    Navigator.pop(context); // Close loading dialog
                    DialogInfo(
                      headerText: "Failed",
                      subText: e.toString(),
                      confirmText: "Try again",
                      onCancel: () {
                        Navigator.pop(context); // Close dialog
                      },
                      onConfirm: () {
                        Navigator.pop(context); // Close dialog
                      },
                    ).build(context);
                    print('Error creating transfer: $e');
                    print('Stack Trace: $stackTrace');
                  }
                } else {
                  Navigator.pop(context); // Close loading dialog if user is null
                  _showErrorDialog('User not logged in.'); // Show error if user is not found
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          )
          ],
          ),
        ),
      ),
    );
  }
}
