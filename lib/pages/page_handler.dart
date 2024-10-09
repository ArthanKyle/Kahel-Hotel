import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kahel/constants/colors.dart';
import 'package:kahel/pages/financials/top_up_page.dart';
import 'package:kahel/pages/financials/transfer_money.dart';
import 'package:kahel/pages/profile_page.dart';
import 'package:kahel/pages/view_all_transactions.dart';
import 'package:kahel/pages/voucher_page.dart';
import 'package:kahel/utils/index_provider.dart';
import 'package:kahel/widgets/bottomnav/route_button.dart';
import 'package:provider/provider.dart';
import '../utils/booking_provider.dart';
import 'auth/registration_pet_page.dart';
import 'gps_page.dart';
import 'landing_page.dart';
import 'landing_pages/activity_page.dart';
import 'landing_pages/book_page.dart';
import 'landing_pages/payment_page.dart';
import 'landing_pages/pet_profile_page.dart';

class PageHandler extends StatefulWidget {
  const PageHandler({super.key});

  @override
  State<PageHandler> createState() => _PageHandlerState();
}

class _PageHandlerState extends State<PageHandler> {
  @override
  Widget build(BuildContext context) {
    final bookingDetails = Provider.of<BookingDetailsProvider>(context);

    final pages = [
      const LandingPage(),
      const GPSPage(),
      const VoucherPage(),
      const ProfilePage(),
      const BookService(),
      const ActivityTracker(),
      const PetProfilePage(),
      const RegistrationPetPage(),
      PaymentPage(
        fromDate: bookingDetails.fromDate,
        toDate: bookingDetails.toDate,
        notes: bookingDetails.notes,
        petName: bookingDetails.petName,
        selectedPackage: bookingDetails.selectedPackage,
        selectedPrice: bookingDetails.selectedPrice,
      ),
      const TopUpPage(),
      const ViewAllTransactions(),
      const TransferMoneyPage(),
    ];

    int pageIndex = Provider.of<PageIndexProvider>(context).pageIndex;
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return WillPopScope(
      onWillPop: () async {
        if (pageIndex == 0) SystemNavigator.pop();
        changePage(index: 0, context: context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: IndexedStack(
          index: pageIndex,
          children: pages,
        ),
        backgroundColor: ColorPalette.accentWhite,
        bottomNavigationBar: _buildBottomNavBar(pageIndex),
        floatingActionButton: isKeyboardVisible
            ? null
            : _buildFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildBottomNavBar(int pageIndex) {
    return BottomAppBar(
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: ColorPalette.gray,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                RouteButton(
                  routeName: "Dashboard",
                  filePath: "assets/images/icons/dashboard.png",
                  routeCallback: () => changePage(index: 0, context: context),
                  currentIndex: pageIndex,
                  routeIndex: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: RouteButton(
                    routeName: "Paw Tracks",
                    filePath: "assets/images/icons/paw.png",
                    routeCallback: () => changePage(index: 1, context: context),
                    currentIndex: pageIndex,
                    routeIndex: 1,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: RouteButton(
                    routeName: "Vouchers",
                    filePath: "assets/images/icons/tag.png",
                    routeCallback: () => changePage(index: 2, context: context),
                    currentIndex: pageIndex,
                    routeIndex: 2,
                  ),
                ),
                RouteButton(
                  routeName: "Profile",
                  filePath: "assets/images/icons/profile.png",
                  routeCallback: () => changePage(index: 3, context: context),
                  currentIndex: pageIndex,
                  routeIndex: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return SizedBox(
      height: 70,
      width: 70,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: ColorPalette.primary,
          child: Image.asset(
            "assets/images/icons/paws.png",
            height: 40,
            width: 40,
          ),
        ),
      ),
    );
  }
}
