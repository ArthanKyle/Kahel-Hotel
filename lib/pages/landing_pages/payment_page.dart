import 'package:flutter/material.dart';
import 'package:kahel/api/booking.dart';
import 'package:kahel/constants/colors.dart';
import 'package:kahel/models/transactions.dart';
import 'package:kahel/utils/index_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:kahel/widgets/universal/dialog_info.dart';
import '../../api/linked_accounts.dart';
import '../../models/linked_accounts_model.dart';
import '../../models/user.dart';
import '../../utils/transaction_fee_handler.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import '../../widgets/universal/dialog_loading.dart';
import '../receipts/receipt_page.dart';

class PaymentPage extends StatefulWidget {
  final String fromDate;
  final String toDate;

  final String petName;
  final String selectedPackage;
  final double selectedPrice;

  const PaymentPage({
    super.key,
    required this.fromDate,
    required this.toDate,

    required this.petName,
    required this.selectedPackage,
    required this.selectedPrice,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String userName = 'Loading...';
  String userEmail = 'Loading...';
  bool isLoading = true;
  List<LinkAccountsModel> linkedAccounts = [];
  String selectedAccountName = '';
  bool agreeToTerms = false;
  int selectedMethod = 0;
  static const double classicPodWeekdayPrice = 900;
  static const double classicPodWeekendPrice = 1000;
  static const double deluxePodWeekdayPrice = 1000;
  static const double deluxePodWeekendPrice = 1100;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchLinkedAccounts();
  }

  double calculateTotalPrice() {
    DateTime fromParsed = DateFormat('yyyy-MM-dd').parseStrict(widget.fromDate);
    DateTime toParsed = DateFormat('yyyy-MM-dd').parseStrict(widget.toDate);
    Duration duration = toParsed.difference(fromParsed);

    double pricePerHour = 0;

    // Set the price based on the selected package
    if (widget.selectedPackage == "Classic Pod") {
      pricePerHour = (fromParsed.weekday == 6 || fromParsed.weekday == 7)
          ? classicPodWeekendPrice
          : classicPodWeekdayPrice;
    } else if (widget.selectedPackage == "Deluxe Pod") {
      pricePerHour = (fromParsed.weekday == 6 || fromParsed.weekday == 7)
          ? deluxePodWeekendPrice
          : deluxePodWeekdayPrice;
    }

    double totalPrice = pricePerHour + (duration.inHours > 0 ? duration.inHours : 1); // Ensure at least 1 hour
    return totalPrice;
  }


  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          UserModel userData = UserModel.fromSnapshot(snapshot);
          setState(() {
            userName = userData.name;
            userEmail = userData.email;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _fetchLinkedAccounts() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<LinkAccountsModel> accounts = await fetchedLinkedAccounts(
            uid: user.uid);
        setState(() {
          linkedAccounts = accounts;
        });
      }
    } catch (e) {
      print('Error fetching linked accounts: $e');
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 20),
            _buildAppBar(),
            const SizedBox(height: 20),
            _buildPaymentForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Stack(
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
          "Payment Details",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: ColorPalette.accentBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentForm(BuildContext context) {
    double totalPrice = calculateTotalPrice(); // Calculate the total price here
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle("Payment Method"),
          const SizedBox(height: 12),
          linkedAccounts.isNotEmpty
              ? Column(
            children: List.generate(linkedAccounts.length, (index) {
              return Column(
                children: [
                  buildPaymentMethodCard(
                    methodTitle: linkedAccounts[index].bank,
                    methodImage: "assets/images/icons/${linkedAccounts[index].bank.toLowerCase()}.png",
                    cardNumber: "**** **** ${linkedAccounts[index].accountNumber.substring(linkedAccounts[index].accountNumber.length - 3)}",
                    value: index,
                    onSelected: () {
                      setState(() {
                        selectedAccountName = linkedAccounts[index].bank;
                        selectedMethod = index;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          )
              : const Center(child: Text('No linked bank accounts found.')),
          const SectionTitle("Payment Information"),
          const SizedBox(height: 12),
          buildPaymentInfoTile("Name", userName),
          buildPaymentInfoTile("From Date", widget.fromDate),
          buildPaymentInfoTile("To Date", widget.toDate),
          buildPaymentInfoTile("Contact", userEmail),
          const SizedBox(height: 24),
          buildPriceInfo("Sub Total", formatPrice(totalPrice)),
          buildPriceInfo("Downpayment", formatPrice(totalPrice)),
          const Divider(thickness: 1.5, color: ColorPalette.gray),
          buildPriceInfo("Total", formatPrice(totalPrice)),
          const SizedBox(height: 12),
          buildTermsAndConditions(),
          const SizedBox(height: 16),
          _buildPayButton(context),
        ],
      ),
    );
  }

  Widget buildPaymentMethodCard({
    required String methodTitle,
    required String methodImage,
    required String cardNumber,
    required int value,
    required VoidCallback onSelected, // Add this parameter
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = value;
        });
        onSelected(); // Call the onSelected callback when this method is tapped
      },
      child: Card(
        color: selectedMethod == value ? ColorPalette.primary : ColorPalette.accentWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(methodImage, height: 40),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    methodTitle,
                    style: TextStyle(
                      color: selectedMethod == value ? ColorPalette.accentWhite : ColorPalette.accentBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cardNumber,
                    style: TextStyle(
                      color: selectedMethod == value ? ColorPalette.accentWhite : ColorPalette.accentBlack,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Radio(
                value: value,
                groupValue: selectedMethod,
                onChanged: (int? val) {
                  setState(() {
                    selectedMethod = val!;
                  });
                  onSelected(); // Call the onSelected callback when the radio button is changed
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPayButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primary,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
        ),
        onPressed: () {
          _confirmPayment(context);
        },
        child: const Text(
          "Pay Now",
          style: TextStyle(fontSize: 18,
              fontFamily: 'Poppins',
              color: ColorPalette.accentWhite),
        ),
      ),
    );
  }

  void _confirmPayment(BuildContext context) async {
    DialogLoading(subtext: "Creating...").build(context);
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (widget.petName != null && widget.fromDate != null &&
          widget.toDate != null && widget.selectedPackage != null &&
          widget.selectedPrice != null) {
        try {
          print('From Date: ${widget.fromDate}');
          print('To Date: ${widget.toDate}');

          if (widget.fromDate.isEmpty || widget.toDate.isEmpty) {
            throw Exception('From Date or To Date cannot be empty.');
          }

          DateTime now = DateTime.now();
          String formattedDate = DateFormat('MMM dd yyyy').format(now);
          String formattedTime = DateFormat('h:mm a').format(now);
          // Update the date format here
          DateTime fromParsed = DateFormat('yyyy-MM-dd hh:mm a').parseStrict(widget.fromDate);
          DateTime toParsed = DateFormat('yyyy-MM-dd hh:mm a').parseStrict(widget.toDate);

          if (fromParsed.isAfter(toParsed)) {
            throw Exception('From Date must be before To Date.');
          }

          if (widget.selectedPackage == "Half-Day Package") {
            Duration duration = toParsed.difference(fromParsed);
            if (duration.inHours < 4) {
              throw Exception('For half-day packages, the duration must be at least 4 hours.');
            }
          }

          double parsedPrice = widget.selectedPrice;
          String transactionId = generateRandomCode(12);

          // Create the booking
          await createBooking(
            uid: user.uid,
            petName: widget.petName,
            fromDate: fromParsed,
            toDate: toParsed,
            package: widget.selectedPackage,
            price: parsedPrice.toString(),
            transactionId: transactionId,
            paymentMethod:  _getSelectedPaymentMethod(),
          );

          double pointsEarned = parsedPrice * 0.002;

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users').doc(user.uid).get();
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          double currentPawKoins = (data['pawKoins'] ?? 0).toDouble();

          double newPawKoins = currentPawKoins + pointsEarned;
          await FirebaseFirestore.instance.collection('users')
              .doc(user.uid)
              .update({'pawKoins': newPawKoins});

          Navigator.of(context).pop();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReceiptPage(
                data: TransactionModel(
                  uid: user.uid,
                  createdAt: formattedDate,
                  amount: parsedPrice.toStringAsFixed(2),
                  amountType: "Booking",
                  type: "Payment Status",
                  recipient: "Pet Hotel",
                  desc: "Your Payment has been successfully done.",
                  time: DateFormat.jm().format(DateTime.now()),
                  senderLeftHeadText: "Transfer from",
                  senderLeftSubText: selectedAccountName,
                  senderRightHeadText: userName,
                  senderRightSubText: widget.petName,
                  recipientLeftHeadText: "To",
                  recipientLeftSubText: "Kahel's PAWsitive Walks",
                  recipientRightHeadText: "Package",
                  recipientRightSubText: widget.selectedPackage,
                  transactionId: transactionId,
                  pointsEarned: pointsEarned,
                  transactionFee: '10.00',
                ),
                onExit: () {
                  Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                },
              ),
            ),
          );
        } catch (e, stackTrace) {
          // Print the error and the stack trace to the console
          print('Error creating booking: $e');
          print('Stack Trace: $stackTrace');
          Navigator.of(context).pop();
          _showErrorDialog('Error creating booking: $e');
        }
      } else {
        DialogInfo(
            headerText: "Error!",
            subText: "Booking details are incomplete.",
            confirmText: "Confirm",
          onCancel: () {
            Navigator.of(context).pop();
          },
          onConfirm: () {
            Navigator.of(context).pop();
          },
        ).build(context);
        print('Booking details are incomplete.');
      }
    }
  }


  Widget buildPriceInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: ColorPalette.gray,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: ColorPalette.accentBlack,
            ),
          ),
        ],
      ),
    );
  }

  String formatPrice(double price) {
    String priceString = price.toStringAsFixed(2);
    return 'PHP ${priceString.replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (match) => '${match.group(1)},'
    )}';
  }

  Widget buildPaymentInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
              )),
          Text(value,
              style: const TextStyle(
              fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget buildTermsAndConditions() {
    return Center( // Center the row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Center the checkbox and text vertically
        children: [
          // Wrap the Checkbox in a Container to center it vertically
          Container(
            alignment: Alignment.center,
            child: Checkbox(
              value: agreeToTerms,
              onChanged: (value) {
                setState(() {
                  agreeToTerms = value ?? false;
                });
              },
            ),
          ),
          const Expanded(
            child: Text(
              "I agree to the terms and conditions.",
              style: TextStyle(fontSize: 14, fontFamily: 'Poppins',),
              textAlign: TextAlign.center, // Center the text
            ),
          ),
        ],
      ),
    );
  }
  String _getSelectedPaymentMethod() {
    if (selectedMethod < linkedAccounts.length) {
      return linkedAccounts[selectedMethod].bank; // Or another property if you have a specific value
    }
    return '';
  }

}


  class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ColorPalette.accentBlack,
      ),
    );
  }
}