import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';

class DatePickerSheer extends StatefulWidget {
  final Function onDateTimeChanged;
  final DateTime initialDateTime;
  final TextEditingController dateController;

  const DatePickerSheer({
    super.key,
    required this.onDateTimeChanged,
    required this.initialDateTime,
    required this.dateController,
  });
  @override
  DateTimePickerSheerState createState() => DateTimePickerSheerState();
}

class DateTimePickerSheerState extends State<DatePickerSheer> {
  // Variable to store the selected date and time
  DateTime pickedDate = DateTime.now();
  DateTime initialDateTime = DateTime.now();
  late final Function onDateTimeChanged;
  late final TextEditingController dateController;
  late final Function onBuild;
  @override
  void initState() {
    super.initState();
    onDateTimeChanged = widget.onDateTimeChanged;
    dateController = widget.dateController;
  }

  // Function to show the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      //set the new state for the description textfields to update the view
      setState(() {
        // Update the selected date and time with the new date
        pickedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedDate.hour,
          pickedDate.minute,
        );
        //set the text of the textfields for the date

        dateController.text = getDateStringForDisplay(pickedDate);

        // Call the callback function with the new date and time
        onDateTimeChanged(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //initialize the dates in the build
    //because it would not redraw when choosing a different list item when using it in Listview Pattern
    initialDateTime = widget.initialDateTime;
    pickedDate = initialDateTime;
    dateController.text = getDateStringForDisplay(pickedDate);
    return Row(
      // Center the children along the main axis (horizontal)
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              // Show the date picker first
              await _selectDate(context);
            },
            child: const Text('Select Date and Time'),
          ),
        ),
        // Text widget to display the selected date and time in a different format
        Expanded(
          child: Center(
            child: TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date'),
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }
}

///This method returns the selected Date and Time as a Future of a datepicker.
///this method is state independent so it can be used where we dont need to build the widget with textfields
Future<DateTime> selectDateStatic(
    BuildContext context, DateTime initialDate) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked != null) {
    return DateTime(
      picked.year,
      picked.month,
      picked.day,
      initialDate.hour,
      initialDate.minute,
    );
  }
  return initialDate;
}
