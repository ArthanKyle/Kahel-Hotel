import 'package:flutter/material.dart';
import '../utils/index_provider.dart';
import '../widgets/universal/user_status_bar.dart';

class GPSPage extends StatefulWidget {
  const GPSPage({super.key});

  @override
  State<GPSPage> createState() => _GPSPageState();
}

class _GPSPageState extends State<GPSPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          const SizedBox(height: 40),
          HeaderBar(
            subText: "track and locate",
            headText: "GPS",
            onPressProfile: () => changePage(index: 3, context: context),
            onPressNotif: () {},
          ),
          const SizedBox(height: 20),

// Map widget placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                'Map Placeholder',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Recent Activity section
          const Text(
            'Recent Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          _buildActivityCard('10 mins walk', '6:31 pm - 6:41 pm', Colors.grey[850]!),
          const SizedBox(height: 10),
          _buildActivityCard('15 mins walk', '5:31 pm - 5:46 pm', Colors.grey[850]!),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, String time, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.pets, size: 30, color: Colors.white),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                time,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}