import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../models/user.dart';

class PawKoin extends StatefulWidget {
  const PawKoin({Key? key}) : super(key: key);

  @override
  State<PawKoin> createState() => _PawKoinState();
}

class _PawKoinState extends State<PawKoin> {
  String? uid;

  @override
  void initState() {
    super.initState();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        uid = currentUser.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text("No user data found!");
        }

        UserModel user = UserModel.fromSnapshot(snapshot.data!);

        return Container(
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 18.5),
          decoration: BoxDecoration(
            color: ColorPalette.accentWhite,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/icons/pawkoin.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Paw Koins",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "${user.pawKoins.toStringAsFixed(2)} ",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: ColorPalette.accentBlack,
                            ),
                            children: [
                              TextSpan(
                                text: "as of ${DateFormat('MMM dd').format(DateTime.now())}",
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: ColorPalette.accentBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: user.pawKoins / 100000,
                        backgroundColor:
                        ColorPalette.gray.withOpacity(0.3),
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(ColorPalette.primary),
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text.rich(
                      TextSpan(
                        text: "Koins can be converted to discount voucher ",
                        style: TextStyle(
                          color: Color(0xff6C6C6C),
                          fontFamily: 'Poppins',
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: "50 koins = 10% of voucher",
                            style: TextStyle(
                              color: Color(0xff6C6C6C),
                              fontFamily: 'Poppins',
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
