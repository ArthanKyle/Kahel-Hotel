import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  String transactionFee = "0";

  final _formKey = GlobalKey<FormState>();
  User? user;

  @override
  void initState() {
    user = getUser();
    super.initState();
  }

  Future<bool> checkIfAccountExists(String accountNumber) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('linked_accounts')
          .where('accountNumber', isEqualTo: accountNumber)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error fetching linked account: $e');
      return false;
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
      backgroundColor: ColorPalette.accentWhite, // Make sure ColorPalette is defined
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
                    left: 0, // Adjust the position of the back arrow if needed
                    child: ArrowBack(
                      onTap: () {
                        changePage(index: 3, context: context); // Make sure changePage is defined
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
    bool accountExists = await checkIfAccountExists(accountToSend);

    if (!accountExists) {
      _showErrorDialog("The account number does not exist.");
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;
    print("Proceeding with transfer to account: $accountToSend");
  }
}
