import 'package:flutter/material.dart';
import 'package:kahel/api/booking.dart';
import 'package:kahel/constants/colors.dart';
import 'package:kahel/models/transactions.dart';
import 'package:kahel/utils/index_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:kahel/widgets/universal/dialog_info.dart';
import 'package:kahel/widgets/universal/dialog_terms_and_conditions.dart';
import '../../api/linked_accounts.dart';
import '../../models/bookingModel.dart';
import '../../models/linked_accounts_model.dart';
import '../../models/user.dart';
import '../../utils/transaction_fee_handler.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import '../../widgets/universal/dialog_loading.dart';
import '../../widgets/universal/dialog_voucher.dart';
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
  String userId = '';
  bool isLoading = true;
  List<LinkAccountsModel> linkedAccounts = [];
  String selectedAccountName = '';
  bool termsRead = false;
  bool agreeToTerms = false;
  int selectedMethod = 0;
  String? selectedVoucher;
  List<String> vouchers = [];
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

    try {
      // Parse the date and time with the 'yyyy-MM-dd hh:mm a' format
      DateTime fromParsed = DateFormat('yyyy-MM-dd hh:mm a').parseStrict(widget.fromDate);
      DateTime toParsed = DateFormat('yyyy-MM-dd hh:mm a').parseStrict(widget.toDate);
      Duration duration = toParsed.difference(fromParsed);
      int numberOfNights = duration.inDays > 0 ? duration.inDays : 1;
      double pricePerNight = 0;

      // Set the price per night based on the package and the day of the week
      if (widget.selectedPackage == "Classic Pod") {
        pricePerNight = (fromParsed.weekday == 6 || fromParsed.weekday == 7) // Weekend check
            ? 1000 // Classic Pod weekend price
            : 900; // Classic Pod weekday price
      } else if (widget.selectedPackage == "Deluxe Pod") {
        pricePerNight = (fromParsed.weekday == 6 || fromParsed.weekday == 7) // Weekend check
            ? 1100 // Deluxe Pod weekend price
            : 1000; // Deluxe Pod weekday price
      }
      double totalPrice = pricePerNight * numberOfNights;
      return totalPrice;
    } catch (e) {
      print("Error parsing dates: $e");
      throw const FormatException("Invalid date format. Please use 'yyyy-MM-dd hh:mm a'.");
    }
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
    double totalPrice = calculateTotalPrice();
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
          buildVoucherInfo(
              'Kahel Voucher',
               userId,
              (){
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return VoucherSelectionDialog(
                          userId: userId,
                          onVoucherSelected:
                          (selected){
                            setState(() {
                              selectedVoucher = selected;
                            });
                            Navigator.pop(context);
                          });
                    }
                );
              }
          ),
          buildPriceInfo("Sub Total", formatPrice(totalPrice)),
          buildPriceInfo("Downpayment", formatPrice(totalPrice / 2)),
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
    required VoidCallback onSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = value;
        });
        onSelected();
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
      try {
        String transactionId = generateRandomCode(12);
        double pointsEarned = calculateTotalPrice() * 0.002;

        BookingModel data = BookingModel(
          uid: user.uid,
          petName: widget.petName,
          fromDate: DateFormat('yyyy-MM-dd hh:mm a').parseStrict(widget.fromDate),
          toDate: DateFormat('yyyy-MM-dd hh:mm a').parseStrict(widget.toDate),
          package: widget.selectedPackage,
          price: calculateTotalPrice().toString(),
          transactionId: transactionId,
          paymentMethod: _getSelectedPaymentMethod(),
        );

        TransactionModel transaction = await createBooking(
          data: data,
          uid: user.uid,
          pointsEarned: pointsEarned,
          petName: widget.petName,
          fromDate: DateFormat('yyyy-MM-dd hh:mm a').parseStrict(widget.fromDate),
          toDate: DateFormat('yyyy-MM-dd hh:mm a').parseStrict(widget.toDate),
          package: widget.selectedPackage,
          price: calculateTotalPrice().toString(),
          paymentMethod: _getSelectedPaymentMethod(),
        );
        Navigator.pop(context);
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
        print('Error creating booking: $e');
        print('Stack Trace: $stackTrace');
      }
    } else {
      Navigator.pop(context); // Close loading dialog if user is null
      _showErrorDialog('User not logged in.'); // Show error if user is not found
    }
  }



  Widget buildVoucherInfo(String title, String userId, VoidCallback onSelectVoucher) {
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
              color: ColorPalette.greyish,
            ),
          ),
          GestureDetector(
            onTap: onSelectVoucher,
            child: const Row(
              children: [
                Text(
                  'Select Voucher',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: ColorPalette.gray,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: ColorPalette.gray,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
              color: ColorPalette.greyish,
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
              fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w500
              )
          ),
        ],
      ),
    );
  }

  Widget buildTermsAndConditions() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => TermsAndConditionsDialog(
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onConfirm: () {
                    setState(() {
                      agreeToTerms = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
            child: const Text(
              "I agree to the terms and conditions.",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                decoration: TextDecoration.underline,
                color: Colors.blue, // Optional: Change color to make it look like a link
              ),
              textAlign: TextAlign.center,
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