import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';


class SleepCard extends StatelessWidget {
  final String sleepTitle;
  final String iconPath;
  final String duration;
  final String sleepInformation;
  final String sleepTime;
  final String wakeUpTime;

  const SleepCard({
    Key? key,
    required this.sleepTitle,
    required this.iconPath,
    required this.duration,
    required this.sleepInformation,
    required this.sleepTime,
    required this.wakeUpTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: ColorPalette.primary,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 150,
                height: 180,
                decoration: BoxDecoration(
                  color: ColorPalette.accentOrange,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconPath,
                      width: 70,
                      height: 70,
                      color: ColorPalette.accentBlack,
                    ),
                    const SizedBox(height: 10), // Add spacing between image and text
                    Text(
                      "Sleeping Time", // Display the title here
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.accentBlack,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/icons/clock.png", // Use iconPath for the icon
                          width: 15,
                          height: 15,
                          color: ColorPalette.accentBlack,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "5 mins ago",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: ColorPalette.accentBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        sleepTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        duration,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sleepInformation,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Went to sleep: $sleepTime',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Woke up: $wakeUpTime',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
