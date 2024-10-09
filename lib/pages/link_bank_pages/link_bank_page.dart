
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kahel/pages/link_bank_pages/success_link_bank.dart';
import '../../api/auth.dart';
import '../../api/link_bank.dart';
import '../../constants/colors.dart';
import '../../utils/input_validators.dart';
import '../../widgets/registration/text_field.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import '../../widgets/universal/dialog_info.dart';
import '../../widgets/universal/dialog_loading.dart';

class LinkBankPage extends StatefulWidget {
  final String bank;
  const LinkBankPage({super.key, required this.bank});

  @override
  State<LinkBankPage> createState() => _LinkBankPageState();
}

class _LinkBankPageState extends State<LinkBankPage> {
  TextEditingController accountName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  bool? isChecked = false;
  final _formKey = GlobalKey<FormState>();

  User? user = getUser();
  bool hasAlreadyFiveAccounts = false;

  @override
  void initState() {
    user = getUser();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hasFiveAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = identifyCardColor(bank: widget.bank);
    String imagePath = identifyImagePath(bank: widget.bank);

    if (hasAlreadyFiveAccounts) {
      return Scaffold(
        backgroundColor: ColorPalette.bgColor,
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                height: 140,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imagePath,
                      height: 60,
                      width: 60,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "You can't link more than 5 accounts.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: ColorPalette.accentBlack,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Text(
                  "Go back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: ColorPalette.accentBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: ArrowBack(onTap: () => Navigator.of(context).pop()),
                  ),
                  const Text(
                    "Link Bank Accounts",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 140,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      imagePath,
                      height: 60,
                      width: 60,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              BasicTextField(
                labelText: "Account Name",
                controller: accountName,
                validator: (p0) => accountNameValidator(p0),
              ),
              BasicTextField(
                labelText: "Account Number",
                controller: accountNumber,
                inputType: TextInputType.number,
                maxLength: 12,
                validator: (p0) => accountNumberValidator(p0),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Transform.scale(
                      scale: 0.7,
                      child: Checkbox(
                          value: isChecked,
                          activeColor: ColorPalette.primary,
                          onChanged: (newBool) {
                            setState(() {
                              isChecked = newBool;
                            });
                          }),
                    ),
                  ),
                  const Text(
                    "I have read and agreed to the  ",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint("Terms and Conditions Tapped");
                    },
                    child: const Text(
                      "Privacy Policy.",
                      style: TextStyle(
                        color: ColorPalette.primary,
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  if (!isChecked!) {
                    DialogInfo(
                      headerText: "Information!",
                      subText:
                          "You need to agree ot our Privacy Policy to proceed!",
                      confirmText: "Okay",
                      onCancel: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      onConfirm: () {
                        setState(() {
                          isChecked = true;
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                      },
                    ).build(context);
                    return;
                  }

                  DialogLoading(subtext: "Loading").build(context);
                  await linkbankAccount(
                          uid: user!.uid,
                          bank: widget.bank,
                          accountName: accountName.text.trim(),
                          accountNumber: accountNumber.text.trim())
                      .then(
                    (value) {
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuccessBankLinkPage(
                              successMessage:
                                  "Successfully linked your account to ${widget.bank}"),
                        ),
                      );
                    },
                  ).catchError((err) {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogInfo(
                      headerText: "Error",
                      subText: err,
                      confirmText: "Try again",
                      onCancel: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      onConfirm: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ).build(context);
                  });
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
                    fontFamily: 'Montserrat',
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

  String identifyImagePath({required String bank}) {
    String path = "";
    switch (bank) {
      case "MasterCard":
        path = 'assets/images/icons/mastercard.png';
        break;
      case "Visa":
        path = 'assets/images/icons/visa.png';
        break;
      case "Gcash":
        path = 'assets/images/icons/gcash.png';
        break;
      case "Pay Maya":
        path = 'assets/images/icons/PayMaya.png';
        break;
      case "PayPal":
        path = 'assets/images/icons/paypal.png';
        break;
    }
    return path;
  }

  Color identifyCardColor({required String bank}) {
    Color colors = ColorPalette.accent;
    switch (bank) {
      case "MasterCard":
        colors = const Color(0xFF3C80AD);
        break;
      case "Visa":
        colors = const Color(0xFF21246E);
        break;
      case "Gcash":
        colors = const Color(0xff007DFE);
        break;
      case "LandBank":
        colors = const Color(0xff53A472);
        break;
      case "Pay Maya":
        colors = const Color(0xff93C93E);
        break;
      case "PayPal":
        colors = const Color(0xff4892CF);
        break;
    }
    return colors;
  }

  void hasFiveAccounts() async {
    bool? isItFive =
        await checkIfFiveLinkBankAccount(uid: user!.uid, bank: widget.bank);

    if (isItFive == null) return;

    if (isItFive) {
      setState(() {
        hasAlreadyFiveAccounts = true;
      });
    } else {
      hasAlreadyFiveAccounts = false;
    }
  }
}
