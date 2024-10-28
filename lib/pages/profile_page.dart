import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/colors.dart';
import '../utils/index_provider.dart';
import '../widgets/landing/transactions/transaction_container.dart';
import '../widgets/profile/account_acitivity_box.dart';
import '../widgets/profile/profile_details_box.dart';
import '../widgets/universal/dialog_info.dart';
import '../widgets/universal/dialog_loading.dart';
import '../widgets/universal/sub_section_info_closable.dart';
import 'link_bank_pages/list_of_linked_banks.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          const SizedBox(height: 40),
          const ProfileDetailsBox(),
          const SizedBox(height: 20),
          ClosableSubSectionInfo(
            icon: Icons.email_rounded,
            leftHeadText: "Your account is at risk",
            leftSubText:
            "verify your account and help us confirm your identity",
            onClose: () {},
          ),
          const SizedBox(height: 20),
          ClosableSubSectionInfo(
            icon: Icons.local_offer_rounded,
            leftHeadText: "Smart saving with promo",
            leftSubText: "Use the promo during the transaction and get discount",
            onClose: () {},
          ),
          const SizedBox(height: 10),
          const Text("Recent Transactions",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  changePage(index: 10, context: context);
                  print("View All tapped!");

                },
                child: const Text(
                  "View All",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const TransactionContainer(),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                  color: ColorPalette.accentBlack,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const SizedBox(height: 15),
                  ActivityBox(
                      name: "Top - Up",
                      filePath: "assets/images/icons/wallet.png",
                      onTap: () => changePage(context: context, index: 9),
                      iconSizeWidth: 29,
                      iconSizeHeight: 25,
                  ),
                  const SizedBox(height: 15),
                  ActivityBox(
                    name: "Edit Profile",
                    filePath: "assets/images/icons/edit-profile.png",
                    onTap: () {},
                    iconSizeHeight: 32,
                    iconSizeWidth: 25,
                  ),
                  const SizedBox(height: 15),
                  ActivityBox(
                    name: "Linked Bank Accounts",
                    filePath: "assets/images/icons/link.png",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListOfLinkedBanks()),
                      );
                    },
                    iconSizeHeight: 23,
                    iconSizeWidth: 25,
                  ),
                  const SizedBox(height: 15),
                  ActivityBox(
                    name: "Sign-Out",
                    filePath: "assets/images/icons/exit.png",
                    onTap: () async {
                      DialogInfo(
                        headerText: "Quit Kahel?",
                        subText: "Are you sure you want to quit?",
                        confirmText: "Confirm",
                        onCancel: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        onConfirm: () async {
                          Navigator.of(context, rootNavigator: true).pop();

                          DialogLoading(subtext: "Logging out...")
                              .build(context);

                          await FirebaseAuth.instance.signOut();

                          if (!mounted) return;

                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/start", (route) => false);
                        },
                      ).build(context);
                    },
                    iconSizeHeight: 25,
                    iconSizeWidth: 25,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
