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

        ],
      ),
    );
  }
  }

