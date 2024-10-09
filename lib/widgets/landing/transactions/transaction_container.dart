import 'package:flutter/material.dart';
import 'package:kahel/widgets/landing/transactions/transaction.box.dart';
import 'package:kahel/api/transactions.dart';
import 'package:kahel/models/transactions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kahel/widgets/landing/transactions/transaction_box_loading.dart';
import 'package:kahel/widgets/landing/transactions/transaction_empty.dart';
import 'package:kahel/widgets/landing/transactions/transaction_error.dart';
import '../../../pages/receipts/receipt_page.dart';

class TransactionContainer extends StatelessWidget {
  const TransactionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return SizedBox(
      // Set a fixed height for each transaction or allow it to be dynamic
      height: 175,
      child: FutureBuilder<TransactionsRes?>(
        future: apiGetTransactions(uid: user!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return const TransactioBoxLoading();
              },
            );
          }

          if (snapshot.hasError) {
            return TransactionError(error: snapshot.data!.errorMessage);
          }

          List<TransactionModel> list = snapshot.data!.list;
          int incrDelay = 700;

          if (list.isEmpty) {
            return const TransactionEmpty();
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              String toAmount = list[index].amount;

              if (list[index].type == "Withdraw") {
                int currentAmount = int.parse(toAmount);
                int transaction = int.parse(list[index].transactionFee);
                int newAmount = currentAmount - transaction;
                toAmount = newAmount.toString();
              }

              return TransactionBox(
                transactionId: list[index].transactionId,
                amountType: list[index].amountType,
                amount: toAmount,
                index: index,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceiptPage(
                        data: list[index],
                        onExit: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
                date: list[index].createdAt,
                recipient: list[index].recipient,
                note: list[index].note ?? "",
                animationDelay: Duration(milliseconds: incrDelay),
              );
            },
          );
        },
      ),
    );
  }
}
