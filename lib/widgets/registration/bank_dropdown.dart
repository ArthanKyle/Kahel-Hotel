import 'package:flutter/material.dart';
import '../../../constants/borders.dart';
import '../../../constants/colors.dart';
import '../../api/linked_accounts.dart';
import '../../models/linked_accounts_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LinkedAccountDropdown extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;

  const LinkedAccountDropdown({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  State<LinkedAccountDropdown> createState() => _LinkedAccountDropdownState();
}

class _LinkedAccountDropdownState extends State<LinkedAccountDropdown> {
  String? selectedAccount;
  List<LinkAccountsModel> linkedAccounts = []; // List to hold linked accounts

  @override
  void initState() {
    super.initState();
    selectedAccount = widget.controller.text;
    _fetchLinkedAccounts(); // Fetch linked accounts on initialization
  }

  Future<void> _fetchLinkedAccounts() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<LinkAccountsModel> accounts = await fetchedLinkedAccounts(uid: user.uid);
        setState(() {
          linkedAccounts = accounts; // Update the state with fetched accounts
        });
      }
    } catch (e) {
      print('Error fetching linked accounts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            color: ColorPalette.accentBlack,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedAccount?.isNotEmpty == true ? selectedAccount : null,
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              selectedAccount = value; // Update the selected account
              widget.controller.text = value; // Update the controller's text
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) return "Please select an account.";
            return null;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18.5),
            enabledBorder: Inputs.enabledBorder,
            focusedBorder: Inputs.focusedBorder,
            errorBorder: Inputs.errorBorder,
            focusedErrorBorder: Inputs.errorBorder,
            filled: true,
            fillColor: ColorPalette.bgColor,
            errorStyle: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal,
              color: ColorPalette.errorColor,
              fontSize: 12,
            ),
          ),
          items: linkedAccounts.isNotEmpty // Check if the linkedAccounts list is not empty
              ? linkedAccounts.map<DropdownMenuItem<String>>((LinkAccountsModel account) {
            return DropdownMenuItem<String>(
              value: account.bank, // Use the bank name as the value
              child: Text(
                account.bank,
                style: const TextStyle(
                  color: ColorPalette.accentBlack,
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList()
              : [], // Return an empty list if there are no linked accounts
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
