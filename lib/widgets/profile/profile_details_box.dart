import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kahel/widgets/profile/profile_loading.dart';
import '../../../api/auth.dart';
import '../../../api/user.dart';
import '../../../constants/colors.dart';
import '../../../models/profile_card.dart';
import '../../utils/money_formatter.dart';
import '../notifications/notificaton_modal.dart';

class ProfileDetailsBox extends StatelessWidget {
  const ProfileDetailsBox({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = getUser();

    return FutureBuilder(
      future: apiProfileCard(uid: user!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ProfileLoading();
        }

        ProfileCardModel? data = snapshot.data!.data;
        double balance = double.parse(data!.balance);
        String formattedMoney = formatMoney(balance);

        String name = data.name.length >= 15
            ? "${data.name.substring(0, 14)}..."
            : data.name;
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(
                      0,
                      4,
                    ),
                  )
                ],
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF6CA8E),
                    Color(0xFFFEA82F),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/icons/user.png",
                    height: 90,
                    width: 90,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Account Name",
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Account Balance",
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            formattedMoney,
                            style: const TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
              onTap: () => NotifModal(uid: user!.uid).build(context),
                child: const Icon(
                  Icons.notifications_outlined, // Bell icon
                  color: ColorPalette.accentBlack, // Color to match the theme
                  size: 28, // Adjust size as needed
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
