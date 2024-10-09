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
  final List<String> packages = ['Half-Day Package', 'Silver Package', 'Gold Package'];
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
      isHalfDaySelected = packageName == 'Half-Day Package';
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
              const SizedBox(height: 10),
              ArrowBack(onTap: () => changePage(index: 0, context: context)),
              const AuthInfo(headText: "Booking Details", subText: ""),
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
                'Half-Day Package',
                400.00,
                selectedPackage == 'Half-Day Package',
                showDetails: selectedPackage == 'Half-Day Package',
                showHalfDayInclusions: true,
              ),
              const SizedBox(height: 8),
              _buildPackageOption(
                'Silver Package',
                1000.00,
                selectedPackage == 'Silver Package',
                showDetails: selectedPackage == 'Silver Package',
              ),
              const SizedBox(height: 8),
              _buildPackageOption(
                'Gold Package',
                1000.00,
                selectedPackage == 'Gold Package',
                showDetails: selectedPackage == 'Gold Package',
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
                    String fromDate;
                    String toDate;

                    if (isHalfDaySelected) {
                      fromDate = halfDayfromDateController.text;
                      toDate = halfDaytoDateController.text;
                    } else {
                      fromDate = fromDateController.text;
                      toDate = toDateController.text;
                    }

                    String notes = notesController.text;
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
                            notes: notes,
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
    bool isHalfDayPackageSelected = packageName == 'Half-Day Package';

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
                Text(
                  '${price.toStringAsFixed(2)} PHP',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ],
            ),
            if (showDetails) ...[
              const SizedBox(height: 12),
              if (isHalfDayPackageSelected) ...[
                Text(
                  'Schedule: 8am - 2pm & 2pm - 8pm',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Inclusions:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '• Sitting for half a day (6 hrs)\n• 2 meals + Treats\n• Kennel Rent\n• Service Fee',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 12),
                _buildHalfDayDateTimeField('From Date', halfDayfromDateController, halfDaytoDateController),
                const SizedBox(height: 12),
                _buildHalfDayDateTimeField('To Date', halfDaytoDateController, halfDayfromDateController),
                const SizedBox(height: 12),
              ] else ...[
                _buildDateTimeField('From Date', fromDateController),
                const SizedBox(height: 8),
                _buildDateTimeField('To Date', toDateController),
                const SizedBox(height: 8),
                _buildNotesField(),
              ],
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
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                DateTime finalDateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
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

  Widget _buildHalfDayDateTimeField(String label, TextEditingController controller, TextEditingController toController) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(
        color: ColorPalette.accentBlack,
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: ColorPalette.bgColor,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                DateTime finalDateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );

                // Set the 'From Date' in the controller
                controller.text = DateFormat('yyyy-MM-dd hh:mm a').format(finalDateTime);

                // Automatically set the 'To Date' based on the selected 'From Date'
                if (pickedTime.hour == 2) {
                  // If the user selects 2 AM, set 'To Date' to 8 PM of the same day
                  toController.text = DateFormat('yyyy-MM-dd hh:mm a').format(finalDateTime.add(Duration(hours: 18)));
                } else if (pickedTime.hour == 8) {
                  // If the user selects 8 AM, set 'To Date' to 2 PM of the same day
                  toController.text = DateFormat('yyyy-MM-dd hh:mm a').format(finalDateTime.add(Duration(hours: 6)));
                } else if (pickedTime.hour == 14) {
                  // If the user selects 2 PM, set 'To Date' to 8 PM of the same day
                  toController.text = DateFormat('yyyy-MM-dd hh:mm a').format(finalDateTime.add(Duration(hours: 6)));
                } else {
                  // Optional: Clear 'To Date' if the time does not match any range
                  toController.text = ''; // Clear 'To Date' or set a default value as needed
                }
              }
            }
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: ColorPalette.accentWhite,
            width: 2.0,
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




  Widget _buildNotesField() {
    return TextField(
      controller: notesController,
      maxLines: 3,
      style: const TextStyle(
        color: ColorPalette.accentBlack,
      ),
      decoration: InputDecoration(
        labelText: 'Notes',
        filled: true,
        fillColor: ColorPalette.bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: ColorPalette.accentWhite, // Change border color to white
            width: 2.0, // Adjust the width as necessary
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: ColorPalette.accentWhite, // Change border color to white
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: ColorPalette.accentWhite, // Change border color to white
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

