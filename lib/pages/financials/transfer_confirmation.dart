import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../utils/index_provider.dart';
import '../../widgets/universal/auth/arrow_back.dart';

class TransferConfirmation extends StatefulWidget {
  final String accountName;
  final String accountNumber;
  final String sendReceiptTo;
  final double amount;

  const TransferConfirmation({
    Key? key,
    required this.accountName,
    required this.accountNumber,
    required this.sendReceiptTo,
    required this.amount,
  }) : super(key: key);

  @override
  State<TransferConfirmation> createState() => _TransferConfirmationState();
}

class _TransferConfirmationState extends State<TransferConfirmation> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite, // Ensure ColorPalette is defined
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20),
              // Header with back arrow and title
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0, // Adjust the position of the back arrow if needed
                    child: ArrowBack(
                      onTap: () {
                        // Assuming `changePage` is defined to handle page navigation
                        changePage(index: 3, context: context);
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
              // Transfer details
              Container(
                width: double.infinity,
                color: Colors.orange.shade600,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "You are about to transfer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "PHP ${widget.amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "CONFIRMATION",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Account Name
              TextFormField(
                initialValue: widget.accountName,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Account Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Account Number
              TextFormField(
                initialValue: widget.accountNumber,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Account Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Send Receipt To
              TextFormField(
                initialValue: widget.sendReceiptTo,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Send Receipt To",
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              // Confirmation Text
              const Text(
                "Please verify the accuracy and completeness of the details before you proceed",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              const Text(
                "By clicking 'Confirm', You hereby accept full responsibility for this transaction done with your account and MPIN",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your confirmation logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
