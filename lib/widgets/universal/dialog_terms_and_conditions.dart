import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class TermsAndConditionsDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  TermsAndConditionsDialog({
    required this.onCancel,
    required this.onConfirm,
  });

  static const String _termsAndConditions = '''
Welcome to Kahel Hotel! Please read these terms and conditions carefully. By booking with us, you agree to the following policies:

Booking and Reservation Policy:
- A reservation is required to secure your pet's stay at our hotel. Bookings can be made directly with us or through our approved booking application.
- If you choose to book through our online application, a downpayment of 30% of the total amount is required to confirm your reservation. This downpayment is non-refundable but can be credited toward future services if you cancel at least 48 hours prior to the check-in date.
- Full payment is required upon check-in, and any additional services requested during the stay will be charged at the time of check-out.

Late Pick-up Fee:
- We understand that unforeseen delays may occur. However, pets must be picked up by the agreed check-out time.
- A late pick-up fee will be applied if the pet is not picked up within one hour of the scheduled time. The fee is PHP [amount] per hour, and if the pet is not collected by the end of the business day, an additional PHP 700 overnight stay fee will be charged.

Payment Methods:
- We accept various payment methods, including cash and credit/debit cards.

Service Prices and Inclusions:
- Our pet hotel offers a range of packages to suit your pet's needs.
- Late check-out fee: PHP 700.
- Supervision by staff.
- Pet boarding with a climate-controlled environment.
- Meals and unlimited filtered water supply.
- Morning & Evening playtime/walk.
- Room services (cleaning and disinfecting per room).
- Free bath and blow dry (for stays of at least 3 days).
- Prices are subject to change. Any additional services requested during your pet's stay will be added to your final bill.

Cancellations and Refunds:
- Cancellations must be made at least 48 hours prior to the check-in date to receive credit for future stays.
- Cancellations made within 48 hours of check-in will forfeit the down payment.

Tokenization Notice:
- Our services may include the use of cryptocurrency-based tokenization for loyalty points or other non-monetary purposes. Please note that tokens are not accepted as a form of payment for services and cannot be exchanged for cash.

Health and Safety Requirements:
- All pets must be up to date with vaccinations, and proof must be provided at check-in.
- We reserve the right to refuse any pet that appears ill or poses a risk to other guests.

Liability Waiver:
- While we take every precaution to ensure the safety and well-being of your pet, we are not liable for any injuries, illnesses, or accidents that may occur during their stay.

Contact Information:
For questions regarding these terms or to update your booking, please contact us at kahel.pethotel@gmail.com or 09476933067.

By using our services, you acknowledge that you have read and agreed to these terms and conditions.
''';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: ColorPalette.accentWhite,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        height: 700,
        width: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Kahel Hotel Terms and Conditions',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPalette.accentBlack,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _termsAndConditions,
                  style: TextStyle(
                    color: ColorPalette.accentBlack,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    child: const Text(
                      'Disagree',
                      style: TextStyle(
                        color: ColorPalette.accentBlack,
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
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Agree',
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}