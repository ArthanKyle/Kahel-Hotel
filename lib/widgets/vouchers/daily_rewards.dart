import 'package:flutter/material.dart';

class DailyRewardsWidget extends StatefulWidget {
  final String dayText;
  final String points;
  final bool isClaimed;
  final bool isToday;
  final VoidCallback onTap;

  const DailyRewardsWidget({
    Key? key,
    required this.dayText,
    required this.points,
    this.isClaimed = false,
    this.isToday = false,
    required this.onTap,
  }) : super(key: key);

  @override
  _DailyRewardsWidgetState createState() => _DailyRewardsWidgetState();
}

class _DailyRewardsWidgetState extends State<DailyRewardsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isClaimed ? Colors.orange : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: widget.isToday ? Colors.orange.withOpacity(0.2) : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.dayText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Image.asset("assets/images/icons/pawkoin.png", height: 40),
            const SizedBox(height: 10),
            Text(
              widget.points,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.isClaimed)
              Column(
                children: [
                  const Icon(
                    Icons.pets,
                    size: 20,
                    color: Colors.orange,
                  ),
                  if (widget.isToday)
                    const Text(
                      "Come back tomorrow!",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
