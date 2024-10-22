import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class NotificationBox extends StatelessWidget {
  final String date;
  final String sender;
  final String desc;

  const NotificationBox({
    super.key,
    required this.date,
    required this.sender,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: date,
      preferBelow: false,
      textStyle: const TextStyle(
        color: ColorPalette.accentWhite,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w400,
        fontSize: 10,
      ),
      triggerMode: TooltipTriggerMode.tap,
      decoration: BoxDecoration(
        color: ColorPalette.skyBlue,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 157, 157, 157),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPalette.primary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  "assets/images/icons/paws.png",
                  height: 30,
                  width: 30,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sender,
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
