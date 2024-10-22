import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<List<String>> fetchUserVouchers(String userId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('vouchers')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => doc['voucherName'] as String).toList();
  } catch (e) {
    print('Error fetching vouchers: $e');
    return [];
  }
}

class VoucherSelectionDialog extends StatelessWidget {
  final String userId;
  final Function(String) onVoucherSelected;

  const VoucherSelectionDialog({
    Key? key,
    required this.userId,
    required this.onVoucherSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchUserVouchers(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorDialog(context, 'Failed to load vouchers. Please try again.');
        }

        final vouchers = snapshot.data ?? [];

        if (vouchers.isEmpty) {
          return _buildErrorDialog(context, 'You don\'t have any vouchers available.');
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              height: 400, // Adjust height based on your preference
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select a Voucher',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: vouchers.map((voucher) {
                        return ListTile(
                          title: Text(voucher),
                          onTap: () {
                            onVoucherSelected(voucher);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // You can implement the action here if needed
                            Navigator.pop(context); // Close the dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Change to your primary color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorDialog(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          height: 150,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Error',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage: Call this function to show the voucher dialog
void showVoucherDialog(BuildContext context, String userId, Function(String) onVoucherSelected) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return VoucherSelectionDialog(
        userId: userId,
        onVoucherSelected: onVoucherSelected,
      );
    },
  );
}
