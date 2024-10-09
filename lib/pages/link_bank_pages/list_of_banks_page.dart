
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import 'link_bank_page.dart';

class ListOfBankPage extends StatelessWidget {
  ListOfBankPage({Key? key}) : super(key: key);

  final List<Organization> organizations = [
    Organization(name: 'Gcash', logo: 'assets/images/icons/gcash.png'),
    Organization(name: 'Pay Maya', logo: 'assets/images/icons/PayMaya.png'),
    Organization(name: 'MasterCard', logo: 'assets/images/icons/mastercard.png'),
    Organization(name: 'PayPal', logo: 'assets/images/icons/paypal.png' ),
    Organization(name: 'Visa', logo: 'assets/images/icons/visa.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Container(
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
                  "Choose your bank",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: ColorPalette.accentBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: organizations.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LinkBankPage(
                          bank: organizations[index].name,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffCCCCCC)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        organizations[index].logo,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(
                        organizations[index].name,
                        style: const TextStyle(
                          color: ColorPalette.accentBlack,
                          fontFamily: "Montserrat",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Organization {
  final String name;
  final String logo;

  Organization({required this.name, required this.logo});
}

class BankDetailPage extends StatelessWidget {
  final Organization organization;

  const BankDetailPage({Key? key, required this.organization})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(organization.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              organization.logo,
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Organization Details',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Add your organization details here.',
            ),
          ],
        ),
      ),
    );
  }
}
