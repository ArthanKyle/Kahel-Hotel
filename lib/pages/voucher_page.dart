import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kahel/widgets/universal/dialog_loading.dart';
import '../api/auth.dart';
import '../api/voucher.dart';
import '../constants/colors.dart';
import '../utils/index_provider.dart';
import '../widgets/pawkoin/pawkoin.dart';
import '../widgets/universal/auth/arrow_back.dart';
import '../widgets/universal/dialog_info.dart';
import '../widgets/universal/dialog_unsuccessful.dart';
import '../widgets/vouchers/daily_rewards.dart';
import '../widgets/vouchers/voucher_box.dart';
import 'dart:math';

class VoucherPage extends StatefulWidget {
  const VoucherPage({Key? key}) : super(key: key);

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  DateTime today = DateTime.now();
  List<String> claimedDays = [];
  double pawKoins = 0;
  Stream<DocumentSnapshot>? userStream;
  String _timeRemaining = "00:00:00";
  Timer? _timer;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Get current user
    if (user != null) {
      userStream = FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots();
    }
    fetchUserData();
    _startTimer();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        claimedDays = List<String>.from(userDoc['claimedDays'] ?? []);
        pawKoins = (userDoc['pawKoins'] ?? 0).toDouble();
      });
    }
  }

  Future<void> claimReward(String dayText, String points) async {
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      List<String> claimedDays = List<String>.from(userDoc['claimedDays'] ?? []);
      double pawKoins = (userDoc['pawKoins'] ?? 0).toDouble();

      if (!claimedDays.contains(dayText)) {
        int rewardPoints = int.tryParse(points.split(' ')[0]) ?? 0;

        setState(() {
          claimedDays.add(dayText);
          pawKoins += rewardPoints;
        });

        try {
          await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
            'claimedDays': claimedDays,
            'pawKoins': pawKoins,
          });
        } catch (e) {
          print("Error updating Firestore: $e");
        }
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _calculateTimeRemaining();
    });
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final difference = tomorrow.difference(now);

    final hours = difference.inHours;
    final minutes = (difference.inMinutes % 60);
    final seconds = (difference.inSeconds % 60);

    setState(() {
      _timeRemaining = '${hours.toString().padLeft(2, '0')}:' +
          '${minutes.toString().padLeft(2, '0')}:' +
          '${seconds.toString().padLeft(2, '0')}';
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildDailyRewardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Daily Rewards",
          style: TextStyle(
            color: ColorPalette.accentBlack,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        StreamBuilder<DocumentSnapshot>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            }

            final userDoc = snapshot.data!;
            List<String> claimedDays = List<String>.from(userDoc['claimedDays'] ?? []);
            (userDoc['pawKoins'] ?? 0).toDouble();

            return SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: dailyRewards().length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final reward = dailyRewards()[index];
                  bool isToday = reward.dayText == getFormattedDay(today);
                  bool isClaimed = claimedDays.contains(reward.dayText);

                  return DailyRewardsWidget(
                    dayText: reward.dayText,
                    points: reward.points,
                    isClaimed: isClaimed,
                    isToday: isToday,
                    onTap: () {
                      if (isClaimed) {
                        DialogUnsuccessful(
                          headertext: "Claim Failed!",
                          subtext: "You have claimed your daily rewards today!",
                          textButton: "Okay",
                          callback: () {
                            Navigator.of(context).pop();
                          },
                        ).buildUnsuccessfulScreen(context);
                      } else {
                        DialogInfo(
                          headerText: "Claim Daily Reward",
                          subText: "Are you ready to claim your rewards for ${reward.dayText}?",
                          confirmText: "Confirm",
                          onCancel: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          onConfirm: () async {
                            Navigator.of(context, rootNavigator: true).pop();
                            await claimReward(
                              reward.dayText,
                              reward.points,
                            );
                          },
                        ).build(context);
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  child: ArrowBack(
                      onTap: () {
                        changePage(index: 0, context: context);
                      }
                  )
              ),
              const Text(
                "Your Vouchers",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: ColorPalette.accentBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const PawKoin(),
          const SizedBox(height: 20),
          _buildDailyRewardsSection(),
          const SizedBox(height: 20),
          const Text(
            "Booking Vouchers",
            style: TextStyle(
              color: ColorPalette.accentBlack,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView.builder(
              itemCount: acadVouchs().length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return VoucherBox(
                  headText: acadVouchs()[index].headText,
                  desc: acadVouchs()[index].desc,
                  holder: acadVouchs()[index].holderName,
                  imagePath: "assets/images/icons/worktimecuate-1.png",
                  onTap: () {
                    DialogInfo dialogInfo = DialogInfo(
                      headerText: "Voucher",
                      subText: "Claim this voucher for 50.0 pawKoin?",
                      confirmText: "Confirm",
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onConfirm: () async {
                        DialogLoading loadingDialog = DialogLoading(subtext: 'Processing....');
                        loadingDialog.build(context); // Show loading dialog

                        User? currentUser = FirebaseAuth.instance.currentUser; // Get the current user
                        if (currentUser != null) {
                          String userId = currentUser.uid;
                          String userName = currentUser.displayName ?? "Unknown User"; // Get username

                          // Generate a voucher code
                          String voucherCode = generateVoucherCode(8); // Generate a voucher code of length 8
                          double discountValue = 10.0; // Set the discount value for the voucher
                          double pawKoinDeduction = 50.0; // Deduct 50 pawKoins from the user's balance

                          UserService userService = UserService();

                          try {
                            // First, deduct the 50 pawKoins
                            bool deductionSuccess = await userService.deductPawKoin(userId, pawKoinDeduction);

                            if (deductionSuccess) {
                              // If deduction is successful, proceed to redeem the voucher
                              bool redemptionSuccess = await userService.redeemVoucher(userId, userName, voucherCode, discountValue);

                              Navigator.of(context).pop(); // Close loading dialog

                              if (redemptionSuccess) {
                                // Close the dialog for claiming and show the success dialog
                                Navigator.of(context).pop(); // Close the claim dialog
                                DialogInfo(
                                  headerText: "Success!",
                                  subText: "Voucher redeemed successfully.",
                                  confirmText: "Okay",
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                  onConfirm: () {
                                    Navigator.of(context).pop(); // Close dialog
                                  },
                                ).build(context);
                              } else {
                                // Log error for failed redemption
                                print("Voucher redemption failed for user: $userId, voucherCode: $voucherCode");
                                DialogUnsuccessful(
                                  headertext: "Redemption Failed!",
                                  subtext: "Could not redeem the voucher. Please try again.",
                                  textButton: "Okay",
                                  callback: () {
                                    Navigator.of(context).pop();
                                  },
                                ).buildUnsuccessfulScreen(context);
                              }
                            } else {
                              // Handle case where pawKoin deduction failed
                              Navigator.of(context).pop(); // Close loading dialog
                              DialogUnsuccessful(
                                headertext: "Deduction Failed!",
                                subtext: "Not enough pawKoin to redeem this voucher. Please check your balance.",
                                textButton: "Okay",
                                callback: () {
                                  Navigator.of(context).pop();
                                },
                              ).buildUnsuccessfulScreen(context);
                            }
                          } catch (e) {
                            // Handle exceptions during the redeem process
                            Navigator.of(context).pop(); // Close loading dialog
                            print("Error during voucher process: $e"); // Log the error
                            DialogUnsuccessful(
                              headertext: "Error!",
                              subtext: "An error occurred. Please try again.",
                              textButton: "Okay",
                              callback: () {
                                Navigator.of(context).pop();
                              },
                            ).buildUnsuccessfulScreen(context);
                          }
                        } else {
                          Navigator.of(context).pop(); // Close loading dialog
                          DialogUnsuccessful(
                            headertext: "Error!",
                            subtext: "User not found. Please log in again.",
                            textButton: "Okay",
                            callback: () {
                              Navigator.of(context).pop();
                            },
                          ).buildUnsuccessfulScreen(context);
                        }
                      },
                    );

                    dialogInfo.build(context);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

String generateVoucherCode(int length) {
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join('');
}

String getFormattedDay(DateTime date) {
  return "Day ${date.day}";
}

List<VoucherType> acadVouchs() {
  return [
    VoucherType("KAHEL HOTEL", "10% off", "upon booking"),
    VoucherType("KAHEL HOTEL", "10% off", "upon booking"),
  ];
}

List<DailyRewards> dailyRewards() {
  return [
    DailyRewards("Day 1", "+5 Koins"),
    DailyRewards("Day 2", "+5 Koins"),
    DailyRewards("Day 3", "+5 Koins"),
    DailyRewards("Day 4", "+5 Koins"),
  ];
}

class VoucherType {
  final String holderName;
  final String headText;
  final String desc;

  VoucherType(this.holderName, this.headText, this.desc);
}

class DailyRewards {
  final String dayText;
  final String points;

  DailyRewards(this.dayText, this.points);
}
