
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../utils/money_formatter.dart';
import '../../widgets/receipt/receipt_info_box.dart';
import '../../widgets/universal/auth/arrow_back.dart';

class ReceiptUnofficialPage extends StatefulWidget {
  final String typeReceipt;
  final String desc;
  final String totalAmount;
  final String amount;
  final String transactionFee;
  final String senderLeftHeadText;
  final String senderLeftSubText;
  final String senderRightHeadText;
  final String senderRightSubText;
  final String receiptLeftHeadText;
  final String receiptLeftSubText;
  final String receiptRightHeadText;
  final String receiptRightSubText;

  final VoidCallback onConfirm;

  const ReceiptUnofficialPage({
    super.key,
    required this.typeReceipt,
    required this.desc,
    required this.totalAmount,
    required this.amount,
    required this.transactionFee,
    required this.senderLeftHeadText,
    required this.senderLeftSubText,
    required this.senderRightHeadText,
    required this.senderRightSubText,
    required this.receiptLeftHeadText,
    required this.receiptLeftSubText,
    required this.receiptRightHeadText,
    required this.receiptRightSubText,
    required this.onConfirm,
  });

  @override
  State<ReceiptUnofficialPage> createState() => _ReceiptUnofficialPageState();
}

class _ReceiptUnofficialPageState extends State<ReceiptUnofficialPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorPalette.bgColor,
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: ArrowBack(onTap: () => Navigator.pop(context)),
                  ),
                  Text(
                    widget.typeReceipt,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 500,
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                decoration: BoxDecoration(
                  color: ColorPalette.accentWhite,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(
                        0,
                        4,
                      ),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Confirmation",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: ColorPalette.accentBlack,
                              ),
                            ),
                            Text(
                              widget.desc,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: ColorPalette.accentBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Container(
                          height: 85,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xffEDEDED),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                formatMoney(double.parse(widget.amount)),
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: ColorPalette.accentBlack,
                                ),
                              ),
                              const Text(
                                "Amount to be transferred",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: ColorPalette.accentBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Column(
                          children: [
                            ReceiptInfoBox(
                              leftHeaderText: "Total amount",
                              rightHeaderText: "P ${widget.totalAmount}",
                              leftSubText: "Transaction Fee",
                              rightSubText: "P ${widget.transactionFee}",
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              color: const Color(0xffD9D9D9),
                            ),
                            const SizedBox(height: 10),
                            ReceiptInfoBox(
                              leftHeaderText: widget.senderLeftHeadText,
                              rightHeaderText: widget.senderRightHeadText,
                              leftSubText: widget.senderLeftSubText,
                              rightSubText: widget.senderRightSubText,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              color: const Color(0xffD9D9D9),
                            ),
                            const SizedBox(height: 10),
                            ReceiptInfoBox(
                              leftHeaderText: widget.receiptLeftHeadText,
                              rightHeaderText: widget.receiptRightHeadText,
                              leftSubText: widget.receiptLeftSubText,
                              rightSubText: widget.receiptRightSubText,
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: widget.onConfirm,
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: ColorPalette.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
