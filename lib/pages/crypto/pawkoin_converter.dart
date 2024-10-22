import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication
import 'package:kahel/utils/index_provider.dart';
import '../../widgets/mpin/mpin.dart';

class PawkoinConverter extends StatefulWidget {
  const PawkoinConverter({super.key});

  @override
  State<PawkoinConverter> createState() => _PawkoinConverterState();
}

class _PawkoinConverterState extends State<PawkoinConverter> {
  double pawKoins = 0.0;
  String conversionRate = "30.20"; // Placeholder conversion rate
  String enteredPawKoins = ""; // Start with an empty string

  @override
  void initState() {
    super.initState();
    fetchPawKoins(); // Call the function to fetch PawKoins when the widget initializes
  }

  Future<void> fetchPawKoins() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get current user
      if (user != null) {
        String uid = user.uid; // Get the UID of the current user
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            pawKoins = userDoc.get('pawKoins')?.toDouble() ?? 0.0;
          });
        }
      }
    } catch (e) {
      print('Error fetching PawKoins: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cryptocurrency Converter"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            changePage(index: 0, context: context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/icons/pawkoin.png',
                        height: 40,
                      ), // Paw Koins icon (replace with your asset path)
                      const SizedBox(width: 10),
                      const Text("Paw Koins =",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Text(
                    "$pawKoins",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // PHP Conversion display
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/icons/philippines_flag.png'), // PHP Flag
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "PHP",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Text(
                    conversionRate,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Currency conversion button
            GestureDetector(
              onTap: () {
                // Handle conversion logic here
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                child: const Icon(
                  Icons.swap_horiz,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20.0), // Increased padding
              width: 370,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Paw Koins",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                children: generateNumberButtons(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generate number buttons (updated)
  List<Widget> generateNumberButtons() {
    List<Widget> numberButtons = [];

    for (int i = 1; i <= 9; i++) {
      numberButtons.add(
        MPINButton(
          textName: "$i",
          onTap: () => enterMPIN("$i"),
        ),
      );
    }
    numberButtons.add(
      MPINButton(textName: "0", onTap: () => enterMPIN("0")),
    );

    // Add dot button on the left side of the '0'
    numberButtons.add(
      MPINButton(textName: ".", onTap: () => enterMPIN(".")),
    );

    // Backspace button
    numberButtons.add(
      IconButton(
        onPressed: () => deletePIN(),
        icon: const Icon(
          Icons.backspace,
          color: Colors.orange,
          size: 30,
        ),
      ),
    );

    return numberButtons;
  }

  void enterMPIN(String value) {
    // Limit the input to 4 digits
    if (enteredPawKoins.length < 4) {
      setState(() {
        enteredPawKoins += value;
      });
    }
  }

  void deletePIN() {
    if (enteredPawKoins.isNotEmpty) {
      setState(() {
        enteredPawKoins =
            enteredPawKoins.substring(0, enteredPawKoins.length - 1);
      });
    }
  }
}
