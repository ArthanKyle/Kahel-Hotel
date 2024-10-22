import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kahel/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kahel/pages/landing_pages/payment_page.dart';
import 'package:kahel/widgets/universal/dialog_info.dart';
import '../../api/booking.dart';
import '../../utils/index_provider.dart';
import '../../widgets/registration/pet_dropdown.dart';
import '../../widgets/universal/auth/arrow_back.dart';
import '../../widgets/universal/auth/auth_info.dart';

class BookService extends StatefulWidget {
  const BookService({super.key});

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController halfDayfromDateController = TextEditingController();
  final TextEditingController halfDaytoDateController = TextEditingController();

  String? selectedPackage = '';
  double selectedPrice = 1000.00;
  final _formKey = GlobalKey<FormState>();
  List<String> userPets = [];
  bool isLoading = true;
  String? uid;
  final List<String> packages = ['Classic Pod', 'Deluxe Pod'];
  bool isHalfDaySelected = false;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    _fetchUserUid();
  }

  Future<void> _fetchUserUid() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        uid = user.uid;
      });
      await _fetchUserPets();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserPets() async {
    if (uid == null) {
      print("UID is null");
      return;
    }

    PetService petService = PetService();
    print("Fetching pets for UID: $uid");
    List<String> pets = await petService.fetchUserPets(uid!);

    setState(() {
      userPets = pets;
      isLoading = false;
    });
  }

  void _onPackageSelected(String packageName, double price) {
    setState(() {
      selectedPackage = packageName;
      selectedPrice = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      child: ArrowBack(
                          onTap: () {
                            changePage(index: 3, context: context);
                          }
                      )
                  ),
                  const Text(
                    "Booking Details",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              PetNameDropdown(
                labelText: 'Pet Name',
                controller: petNameController,
                petNames: userPets.isEmpty ? ['No pets available'] : userPets,
              ),
              const SizedBox(height: 10),
              const Text(
                "Choose a Package",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              _buildPackageOption(
                'Classic Pod',
                900.00,
                selectedPackage == 'Classic Pod',
                showDetails: selectedPackage == 'Classic Pod',
                showHalfDayInclusions: true,
              ),
              const SizedBox(height: 8),
              _buildPackageOption(
                'Deluxe Pod',
                1000.00,
                selectedPackage == 'Deluxe Pod',
                showDetails: selectedPackage == 'Deluxe Pod',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String  fromDate = fromDateController.text;
                    String  toDate = toDateController.text;
                    String petName = petNameController.text;
                    String packageToPass = selectedPackage ?? '';
                    double selectedPrice = this.selectedPrice;

                    if (fromDate.isNotEmpty && toDate.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            fromDate: fromDate,
                            toDate: toDate,
                            petName: petName,
                            selectedPackage: packageToPass,
                            selectedPrice: selectedPrice,
                          ),
                        ),
                      );
                    } else {
                      DialogInfo(
                        headerText: 'Invalid Dates',
                        subText: 'Please select valid dates.',
                        confirmText: 'OK',
                        onCancel: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        onConfirm: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ).build(context);
                    }
                  }
                },
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageOption(
      String packageName,
      double price,
      bool isSelected, {
        bool showDetails = false,
        bool showHalfDayInclusions = false,
      }) {
    bool isHalfDayPackageSelected = packageName == 'Classic Pod';

    return GestureDetector(
      onTap: () {
        _onPackageSelected(packageName, price);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? ColorPalette.primary : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<String>(
                  value: packageName,
                  groupValue: selectedPackage,
                  onChanged: (value) {
                    _onPackageSelected(packageName, price);
                  },
                  activeColor: Colors.black,
                ),
                const SizedBox(width: 8),
                Text(
                  packageName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ],
            ),
            if (showDetails) ...[
              const SizedBox(height: 12),
              const Text(
                'Inclusions:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '• Supervision of Staff.'
                    '\n• Pet Boarding with a climate-controlled environment.'
                    '\n• Meals and unlimited filtered water supply'
                    '\n• Morning & Evening play time/walk (for boarding pets)'
                    '\n• Room Services (cleaning and disinfecting per room)'
                    '\n• Free bath and blow dry (for boarding at least 3 days)',
                style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 12),
              _buildDateTimeField('From Date', fromDateController),
              const SizedBox(height: 12),
              _buildDateTimeField('To Date', toDateController),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildDateTimeField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(
        color: ColorPalette.accentBlack, // Adjusted text color
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: ColorPalette.bgColor, // Added fill color
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            // Show date picker
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              // Show time picker if a date is selected
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                // Combine the date and time into a single DateTime object
                DateTime finalDateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );

                // Format both the date and time, including AM/PM
                controller.text = DateFormat('yyyy-MM-dd hh:mm a').format(finalDateTime);
              }
            }
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: ColorPalette.accentWhite,
            width: 2.0, // Adjust the width as necessary
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: ColorPalette.accentWhite,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: ColorPalette.accentWhite,
            width: 2.0,
          ),
        ),
        labelStyle: const TextStyle(
          color: ColorPalette.accentBlack,
        ),
      ),
    );
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    notesController.dispose();
    petNameController.dispose();
    halfDayfromDateController.dispose();
    halfDaytoDateController.dispose();
    super.dispose();
  }
}

