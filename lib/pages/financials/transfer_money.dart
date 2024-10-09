import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kahel/pages/financials/transfer_confirmation.dart';
import '../../api/auth.dart';
import '../../constants/borders.dart';
import '../../constants/colors.dart';
import '../../utils/index_provider.dart';
import '../../utils/input_validators.dart';
import '../../widgets/registration/text_field.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/universal/dialog_info.dart';

class TransferMoneyPage extends StatefulWidget {
  const TransferMoneyPage({Key? key}) : super(key: key);

  @override
  State<TransferMoneyPage> createState() => _TransferMoneyPageState();
}

class _TransferMoneyPageState extends State<TransferMoneyPage> {
  TextEditingController accountNumber = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  String transactionFee = "10.00"; // Set a default transaction fee

  final _formKey = GlobalKey<FormState>();
  User? user;

  @override
  void initState() {
    super.initState();
    user = getUser();
  }

  Future<Map<String, dynamic>?> fetchAccountDetails(String accountNumber) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('linked_accounts')
          .where('accountNumber', isEqualTo: accountNumber)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching linked account: $e');
      return null;
    }
  }

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

  Future<String?> fetchRecipientEmail(String recipientUid) async {
    try {
      // Fetch the recipient's document from the 'users' collection using their UID
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')  // Replace with your users collection name
          .doc(recipientUid)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot['email'];  // Return the recipient's email
      } else {
        print('Recipient user document not found.');
        return null;
      }
    } catch (e) {
      print('Error fetching recipient email: $e');
      return null;  // Return null if there was an error
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
                        changePage(index: 3, context: context);
                      },
                    ),
                  ),
                  const Text(
                    "Transfer Money",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 45),
              BasicTextField(
                labelText: "Transfer to",
                controller: accountNumber,
                validator: (p0) => accountNameValidator(p0),
              ),
              BasicTextField(
                labelText: "Amount",
                controller: amountController,
                validator: (p0) => centavosValidator(amountController.text),
              ),
              const Text(
                "Notes (Optional)",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  color: ColorPalette.accentBlack,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: notesController,
                cursorColor: ColorPalette.accentBlack,
                maxLength: 30,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 18.5),
                  enabledBorder: Inputs.enabledBorder,
                  focusedBorder: Inputs.focusedBorder,
                  errorBorder: Inputs.errorBorder,
                  focusedErrorBorder: Inputs.errorBorder,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: ColorPalette.bgColor,
                  errorStyle: const TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    color: ColorPalette.errorColor,
                    fontSize: 12,
                  ),
                  counterText: "",
                ),
                style: const TextStyle(
                  color: ColorPalette.accentBlack,
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: "A PHP ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: ColorPalette.accentBlack,
                  ),
                  children: [
                    TextSpan(
                      text: "10.00 ", // The amount text
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 11,
                        fontWeight: FontWeight.bold, // Bold style
                        color: ColorPalette.accentBlack,
                      ),
                    ),
                    TextSpan(
                      text: "Transaction fee will be charged per transaction.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: ColorPalette.accentBlack,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _transferMoney,
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
                    color: ColorPalette.accentWhite,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _transferMoney() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    String accountToSend = accountNumber.text.trim();
    String amountToSend = amountController.text.trim();
    String notes = notesController.text.trim();

    // Fetch account details to get the UID
    Map<String, dynamic>? accountDetails = await fetchAccountDetails(accountToSend);
    if (accountDetails == null) {
      _showErrorDialog("The account number does not exist.");
      return;
    }

    // Assuming 'uid' is available in the accountDetails
    String recipientUid = accountDetails['uid'] ?? ''; // Get the UID from account details
    if (recipientUid.isEmpty) {
      _showErrorDialog("Recipient UID not found.");
      return;
    }

    // Optionally, fetch recipient UID from the linked accounts (if needed)
    String? linkedAccountUid = await fetchRecipientUid(recipientUid);
    if (linkedAccountUid == null) {
      _showErrorDialog("The recipient's linked account does not exist.");
      return;
    }

    String accountName = accountDetails['accountName'] ?? '';
    String? userEmail = await fetchRecipientEmail(recipientUid);

    print('Account Number: $accountToSend');
    print('Amount: $amountToSend');
    print('Notes: $notes');
    print('Account Name: $accountName');
    print('User Email: ${userEmail ?? 'example@example.com'}');
    print('Recipient UID: $linkedAccountUid');

    // Navigate to the Transfer Confirmation page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferConfirmation(
          accountNumber: accountToSend,
          amount: amountToSend,
          notes: notes,
          accountName: accountName,
          sendReceiptTo: userEmail ?? 'example@example.com',
          recipientUid: linkedAccountUid,
        ),
      ),
    );
  }
  }

