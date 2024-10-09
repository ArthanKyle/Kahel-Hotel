import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kahel/constants/borders.dart';
import 'package:kahel/constants/colors.dart';

class BookingDate extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;

  const BookingDate({
    super.key,
    required this.labelText,
    required this.controller,
    required IconData icon,
  });

  @override
  State<BookingDate> createState() => _BookingDateState();
}

class _BookingDateState extends State<BookingDate> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            color: ColorPalette.accentBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: true,
          onTap: () => _selectDateTime(context),
          cursorColor: ColorPalette.accentBlack,
          controller: widget.controller,
          validator: (value) {
            if (value!.isNotEmpty) return null;
            return "Please enter your booking date and time!";
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18.5),
            enabledBorder: Inputs.enabledBorder,
            focusedBorder: Inputs.focusedBorder,
            errorBorder: Inputs.errorBorder,
            focusedErrorBorder: Inputs.errorBorder,
            disabledBorder: Inputs.enabledBorder,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: ColorPalette.bgColor,
            errorStyle: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal,
              color: ColorPalette.errorColor,
              fontSize: 12,
            ),
          ),
          style: const TextStyle(
            color: ColorPalette.accentBlack,
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    // Select date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1930, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });

      // Select time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );

      if (pickedTime != null) {
        setState(() {
          selectedTime = pickedTime;
          DateFormat dateFormat = DateFormat("MM/dd/yyyy");
          // Update the text controller with both date and time
          widget.controller.text =
          '${dateFormat.format(selectedDate)} ${selectedTime.format(context)}';
        });
      }
    }
  }
}
