import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kahel/api/top_up.dart';
import 'package:kahel/pages/receipts/receipt_page.dart';
import 'package:kahel/utils/index_provider.dart';
import '../../api/auth.dart';
import '../../api/linked_accounts.dart';
import '../../constants/borders.dart';
import '../../constants/colors.dart';
import '../../models/linked_accounts_model.dart';
import '../../models/top_up_model.dart';
import '../../models/transactions.dart';
import '../../utils/input_validators.dart';
import '../../utils/transaction_fee_handler.dart';
import '../../widgets/registration/text_field.dart';
import '../../widgets/topup/amount_picker_box.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import '../../widgets/universal/dialog_info.dart';
import '../../widgets/universal/dialog_loading.dart';


class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final myRegBox = Hive.box("sessions");
  late String? name = myRegBox.get("name");
  String transactionFee = "0";

  TextEditingController amountController = TextEditingController(text: "50");
  TextEditingController notesController = TextEditingController();
  int currentIndex = 0;
  String currentValue = "50";
  List<String> availableAmounts = ["50", "100", "200", "500", "800", "1000"];
  List<LinkAccountsModel> linkedAccounts = [];
  TextEditingController accountController = TextEditingController();
  String selectedBank = "";
  String selectedAccountNumber = "";
  bool alreadyFetched = false;
  String? value = "";
  final _formKey = GlobalKey<FormState>();

  User? user;

  @override
  void initState() {
    user = getUser();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTransactionFee();
    });
  }

  Future<void> fetchLinkedAccounts() async {
    final accounts = await fetchedLinkedAccounts(uid: user!.uid);
    if (!mounted) return;
    setState(() {
      linkedAccounts = accounts;
      if (linkedAccounts.isNotEmpty) {
        accountController.text = linkedAccounts[0].bank;
      }
    });
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
                      child: ArrowBack(
                          onTap: () {
                            changePage(index: 3, context: context);
                          }
                      )
                  ),
                  const Text(
                    "Top Up",
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
              FutureBuilder(
                future: fetchedLinkedAccounts(uid: user!.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Text(
                          "Fetching Link Accounts...",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ));
                  }

                  List<LinkAccountsModel> list = snapshot.data!;

                  if (list.isEmpty) {
                    return const Center(
                        child: Text(
                          "You need at least 1 bank account linked!",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ));
                  }

                  List<String> stringOnList = [];
                  for (int i = 0; i < list.length; i++) {
                    stringOnList
                        .add("${list[i].bank} ${list[i].accountNumber}");
                  }

                  if (!alreadyFetched) {
                    value = stringOnList[0];
                    selectedBank = list[0].bank;
                    selectedAccountNumber = list[0].accountNumber;
                    alreadyFetched = true;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Account Number",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: ColorPalette.accentBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ColorPalette.textfieldColor,
                          ),
                          color: ColorPalette.bgColor,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              menuMaxHeight: 300,
                              isExpanded: true,
                              value: value,
                              items: stringOnList.map(buildMenuItem).toList(),
                              onChanged: (value) {
                                setState(() {
                                  this.value = value;
                                  selectedBank = value!.split(' ')[0];
                                  selectedAccountNumber = value.split(' ')[1];
                                });
                              }),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              BasicTextField(
                labelText: "Amount",
                controller: amountController,
                validator: (p0) => centavosValidator(amountController.text),
                hintText: "enter specific amount without centavos...",
                inputType: TextInputType.number,
                onChange: (p0) {
                  if (p0.length == 1 && p0 == "0") {
                    amountController.text = "";
                    return;
                  }

                  if (availableAmounts.contains(p0)) {
                    setState(() {
                      currentIndex = availableAmounts.indexOf(p0);
                    });
                  } else {
                    setState(() {
                      currentIndex = -1;
                    });
                  }
                },
              ),
              Row(
                children: [
                  AmountPickerBox(
                    currentIndex: currentIndex,
                    index: 0,
                    amount: "50.00",
                    transacFee: transactionFee,
                    onTap: () => setState(() {
                      currentIndex = 0;
                      amountController.text = "50";
                      amountController.selection = TextSelection.collapsed(
                        offset: amountController.text.length,
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  AmountPickerBox(
                    currentIndex: currentIndex,
                    index: 1,
                    amount: "100.00",
                    transacFee: transactionFee,
                    onTap: () => setState(() {
                      currentIndex = 1;
                      amountController.text = "100";
                      amountController.selection = TextSelection.collapsed(
                        offset: amountController.text.length,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AmountPickerBox(
                    currentIndex: currentIndex,
                    index: 2,
                    amount: "200.00",
                    transacFee: transactionFee,
                    onTap: () => setState(() {
                      currentIndex = 2;
                      amountController.text = "200";
                      amountController.selection = TextSelection.collapsed(
                        offset: amountController.text.length,
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  AmountPickerBox(
                    currentIndex: currentIndex,
                    index: 3,
                    amount: "500.00",
                    transacFee: transactionFee,
                    onTap: () => setState(() {
                      currentIndex = 3;
                      amountController.text = "500";
                      amountController.selection = TextSelection.collapsed(
                        offset: amountController.text.length,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AmountPickerBox(
                    currentIndex: currentIndex,
                    index: 4,
                    amount: "800.00",
                    transacFee: transactionFee,
                    onTap: () => setState(() {
                      currentIndex = 4;
                      amountController.text = "800";
                      amountController.selection = TextSelection.collapsed(
                        offset: amountController.text.length,
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  AmountPickerBox(
                    currentIndex: currentIndex,
                    index: 5,
                    amount: "1000.00",
                    transacFee: transactionFee,
                    onTap: () => setState(() {
                      currentIndex = 5;
                      amountController.text = "1000";
                      amountController.selection = TextSelection.collapsed(
                        offset: amountController.text.length,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
              const Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: "Go to any establishment partners of ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: ColorPalette.accentBlack,
                  ),
                  children: [
                    TextSpan(
                      text: "Kahel ",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: ColorPalette.primary,
                      ),
                    ),
                    TextSpan(
                      text: "for payment*",
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
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  FocusScope.of(context).unfocus();
                  String amountToSend = amountController.text.trim();
                  String transactionFee = this.transactionFee;
                  String? notes = notesController.text.isNotEmpty ? notesController.text : null;
                  String totalExpenses = (double.parse(amountToSend) + double.parse(transactionFee)).toString();
                  double pointsEarned = double.parse(amountToSend) * 0.002;

                  DialogLoading(
                    subtext: "Loading...",
                    willPop: false,
                  ).build(context);

                  // Get the current user
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    try {
                      // Prepare the TopUpModel data
                      TopUpModel data = TopUpModel(
                        linkedAccountId: selectedAccountNumber, // Ensure this variable is defined
                        moneyToSend: amountToSend,
                        totalExpenses: totalExpenses,
                        transactionFee: transactionFee,
                        note: notes,
                        selectedBank: selectedBank,
                      );
                      TransactionModel transaction = await topUp(
                        data: data,
                        userUid: user.uid,
                        pointsEarned: pointsEarned,
                      );
                      Navigator.pop(context); // Close loading dialog
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
                      // Handle any errors
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
                      print('Error creating top up: $e');
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

  void getTransactionFee() async {
    String fetchedFee = await fetchTransactionFee(uid: user!.uid);
    if (!mounted) return;
    setState(() {
      transactionFee = fetchedFee;
    });
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    List<String> info = item.split(' ');
    String bank = info[0];
    String cardNumber = getLastThreeDigits(info[1]);

    // Choose the appropriate icon based on the bank name
    Widget bankIcon;
    if (bank == 'Gcash') {
      bankIcon = Image.asset('assets/images/icons/gcash.png', width: 24, height: 24);
    } else if (bank == 'MasterCard') {
      bankIcon = Image.asset('assets/images/icons/mastercard.png', width: 24, height: 24);
    } else if (bank == 'PayPal') {
      bankIcon = Image.asset('assets/images/icons/paypal.png', width: 24, height: 24);
    } else {
      bankIcon = Icon(Icons.credit_card, size: 24); // Default icon for other banks
    }

    return DropdownMenuItem(
      value: item,
      child: Row(
        children: [
          bankIcon, // Display the icon on the left
          const SizedBox(width: 12), // Space between the icon and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bank,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: ColorPalette.accentBlack,
                ),
              ),
              Text(
                "**** $cardNumber", // Display the card number masked
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getLastThreeDigits(String cardNumber) {
    return cardNumber.substring(cardNumber.length - 3); // Extract the last three digits of the card number
  }

  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
