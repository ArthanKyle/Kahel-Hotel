import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahel/constants/colors.dart';
import 'package:kahel/models/linked_accounts_model.dart';
import 'package:kahel/widgets/universal/auth/arrow_back.dart';
import 'package:kahel/widgets/landing/cards/payment_card.dart';
import 'package:kahel/api/linked_accounts.dart';
import 'list_of_banks_page.dart';

class ListOfLinkedBanks extends StatefulWidget {
  const ListOfLinkedBanks({super.key});

  @override
  State<ListOfLinkedBanks> createState() => _ListOfLinkedBanksState();
}

class _ListOfLinkedBanksState extends State<ListOfLinkedBanks> {
  late Future<List<LinkAccountsModel>> _futureLinkedAccounts;

  @override
  void initState() {
    super.initState();
    _fetchUserLinkedAccounts();
  }

  Future<void> _fetchUserLinkedAccounts() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _futureLinkedAccounts = fetchedLinkedAccounts(uid: user.uid);
      setState(() {});
    }
  }

  Future<double?> _getTransactionAmount(String linkedAccountId) async {
    try {
      QuerySnapshot transactionSnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('recipientRightSubText', isEqualTo: linkedAccountId)
          .get();

      // Log the transaction documents
      for (var doc in transactionSnapshot.docs) {
        print("Transaction: ${doc.data()}");
      }

      double totalAmount = transactionSnapshot.docs.fold(
        0.0,
            (previousValue, document) =>
        previousValue + (document['amount'] as num).toDouble(),
      );

      return totalAmount;
    } catch (e) {
      print("Error fetching transactions: $e");
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Padding(
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
                  child: ArrowBack(onTap: () => Navigator.of(context).pop()),
                ),
                const Text(
                  'Linked Bank Accounts',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: ColorPalette.accentBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<LinkAccountsModel>>(
              future: _futureLinkedAccounts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No linked accounts found.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildAddBankButton(context),
                    ],
                  );
                }

                List<LinkAccountsModel> accounts = snapshot.data!;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: accounts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == accounts.length) {
                      return _buildAddBankButton(context);
                    }

                    LinkAccountsModel account = accounts[index];

                    return FutureBuilder<double?>(
                      future: _getTransactionAmount(account.accountNumber),
                      builder: (context, transactionSnapshot) {
                        if (transactionSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (transactionSnapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error: ${transactionSnapshot.error}'));
                        }

                        double? amount = transactionSnapshot.data ?? 0.0;

                        return PaymentCard(
                          name: account.bank,
                          logo: _getBankLogo(account.bank),
                          color: _getBankColor(account.bank),
                          accountNumber: maskAccountNumber(account.accountNumber),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBankButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListOfBankPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.orange,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline,
              color: Colors.orange,
            ),
            const SizedBox(width: 10),
            const Text(
              'Add another bank',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBankLogo(String bank) {
    switch (bank) {
      case "MasterCard":
        return 'assets/images/icons/mastercard.png';
      case "Visa":
        return 'assets/images/icons/visa.png';
      case "Gcash":
        return 'assets/images/icons/gcash.png';
      case "Pay Maya":
        return 'assets/images/icons/PayMaya.png';
      case "PayPal":
        return 'assets/images/icons/paypal.png';
      default:
        return 'assets/images/icons/default.png'; // Default image
    }
  }

  Color _getBankColor(String bank) {
    switch (bank) {
      case "MasterCard":
        return const Color(0xFF3C80AD);
      case "Visa":
        return const Color(0xFF21246E);
      case "Gcash":
        return const Color(0xff007DFE);
      case "LandBank":
        return const Color(0xff53A472);
      case "Pay Maya":
        return const Color(0xff93C93E);
      case "PayPal":
        return const Color(0xff4892CF);
      default:
        return ColorPalette.accent; // Default color
    }
  }
}
