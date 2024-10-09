import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/transactions.dart';
import '../../utils/index_provider.dart';
import '../../utils/money_formatter.dart';
import '../../widgets/receipt/receipt_info_box.dart';
import '../../widgets/universal/auth/arrow_back.dart';



class ReceiptPage extends StatefulWidget {
  final TransactionModel data;
  final VoidCallback onExit;

  const ReceiptPage({
    super.key,
    required this.data,
    required this.onExit,
  });

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}



class _ReceiptPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorPalette.primary,
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
                    child: ArrowBack(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                      },
                    )
                  ),
                  Text(
                    widget.data.type,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 700,
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                decoration: BoxDecoration(
                  color: ColorPalette.accentWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                            color: ColorPalette.primary,
                            borderRadius: BorderRadius.circular(9999),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check,
                            color: ColorPalette.accentWhite,
                            size: 50,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 30,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: ColorPalette.primary,
                          ),
                          child: Center(
                            child: Text(
                              "+${widget.data.pointsEarned} Paw Koins",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: ColorPalette.accentWhite,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Success",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: ColorPalette.accentBlack,
                              ),
                            ),
                            Text(
                              widget.data.desc,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: ColorPalette.accentBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
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
                          formatMoney(
                          (double.tryParse(widget.data.amount.replaceAll(',', '').trim()) ?? 0.0) +
                          (double.tryParse(widget.data.transactionFee.replaceAll(',', '').trim()) ?? 0.0)
                          ),
                                  style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: ColorPalette.accentBlack,
                                ),
                              ),
                              const Text(
                                "Total Amount",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
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
                              leftHeaderText: "Amount",
                              rightHeaderText: "P ${((double.tryParse(widget.data.amount.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0) +
                                  (double.tryParse(widget.data.transactionFee.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0)).toStringAsFixed(2)}",
                              leftSubText: "Transaction Fee",
                              rightSubText: "P ${widget.data.transactionFee}",
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              color: const Color(0xffD9D9D9),
                            ),
                            const SizedBox(height: 10),
                            ReceiptInfoBox(
                              leftHeaderText: widget.data.senderLeftHeadText,
                              rightHeaderText: widget.data.senderRightHeadText,
                              leftSubText: widget.data.senderLeftSubText,
                              rightSubText: widget.data.senderRightSubText,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              color: const Color(0xffD9D9D9),
                            ),
                            const SizedBox(height: 10),
                            ReceiptInfoBox(
                              leftHeaderText: widget.data.recipientLeftHeadText,
                              rightHeaderText:
                                  widget.data.recipientRightHeadText,
                              leftSubText: widget.data.recipientLeftSubText,
                              rightSubText: widget.data.recipientRightSubText,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              color: const Color(0xffD9D9D9),
                            ),
                            const SizedBox(height: 10),
                            ReceiptInfoBox(
                              leftHeaderText: "Transaction ID",
                              rightHeaderText: widget.data.transactionId,
                              leftSubText: "Date",
                              rightSubText: widget.data.createdAt,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Transform.scale(
                            scale: 0.7,
                            child: Checkbox(
                                value: true,
                                activeColor: ColorPalette.primary,
                                onChanged: (newBool) {
                                  setState(() {});
                                }),
                          ),
                        ),
                        const Text(
                          "Download receipt",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async{
                        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                        },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: ColorPalette.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
