import 'package:flutter/material.dart';

String maskAccountNumber(String accountNumber) {
  if (accountNumber.length <= 3) {
    return accountNumber; // If the account number is 3 digits or less, return it as is
  }
  return '******* ${accountNumber.substring(accountNumber.length - 3)}';
}

class PaymentCard extends StatelessWidget {
  final String name;
  final String logo;
  final Color color;
  final String accountNumber; // Added account number


  const PaymentCard({
    Key? key,
    required this.name,
    required this.logo,
    required this.color,
    required this.accountNumber, // Added account number parameter

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15), // Increased vertical margin
      padding: const EdgeInsets.all(40), // Adjusted padding
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20), // Increased border radius
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8, // Increased blur radius
            offset: Offset(0, 4), // Increased vertical offset
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20, // Increased font size
                    fontWeight: FontWeight.w600, // Updated font weight
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  maskAccountNumber(accountNumber), // Masked account number
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 12, // Font size for account number
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Image.asset(
            logo,
            height: 50,
            width: 50, // Increased image height
          ),
        ],
      ),
    );
  }
}
