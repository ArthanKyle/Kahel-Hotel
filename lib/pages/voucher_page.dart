import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/colors.dart';
import '../utils/index_provider.dart';
import '../widgets/pawkoin/pawkoin.dart';
import '../widgets/universal/dialog_info.dart';
import '../widgets/universal/dialog_unsuccessful.dart';
import '../widgets/universal/user_status_bar.dart';
import '../widgets/vouchers/daily_rewards.dart';
import '../widgets/vouchers/voucher_box.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({Key? key}) : super(key: key);

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  DateTime today = DateTime.now();
  List<String> claimedDays = [];
  double pawKoins = 0;  // Change to double
  Stream<DocumentSnapshot>? userStream;
  String _timeRemaining = "00:00:00";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      userStream = FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
    }
    fetchUserData();
    _startTimer(); // Start the timer to update time remaining
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        claimedDays = List<String>.from(userDoc['claimedDays'] ?? []);
        pawKoins = (userDoc['pawKoins'] ?? 0).toDouble();  // Ensure it's a double
      });
    }
  }

  Future<void> claimReward(String dayText, String points) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      List<String> claimedDays = List<String>.from(userDoc['claimedDays'] ?? []);
      double pawKoins = (userDoc['pawKoins'] ?? 0).toDouble();  // Ensure it's a double

      if (!claimedDays.contains(dayText)) {
        int rewardPoints = int.tryParse(points.split(' ')[0]) ?? 0;

        setState(() {
          claimedDays.add(dayText);
          pawKoins += rewardPoints;  // Add reward points as double
        });

        try {
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'claimedDays': claimedDays,
            'pawKoins': pawKoins,  // Store as double
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
    final tomorrow = DateTime(now.year, now.month, now.day + 1); // Assuming rewards reset at midnight
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
            (userDoc['pawKoins'] ?? 0).toDouble();  // Ensure it's a double

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
        children: [
          const SizedBox(height: 40),
          HeaderBar(
            subText: "spend wise and use",
            headText: "Your Vouchers",
            onPressProfile: () => changePage(index: 3, context: context),
            onPressNotif: () {},
          ),
          const SizedBox(height: 20),
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
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
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
