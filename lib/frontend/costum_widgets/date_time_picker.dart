import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';

class DateTimePickerSheer extends StatefulWidget {
  final Function onDateTimeChanged;
  final DateTime initialDateTime;

  const DateTimePickerSheer({
    super.key,
    required this.onDateTimeChanged,
    required this.initialDateTime,
  });
  @override
  DateTimePickerSheerState createState() => DateTimePickerSheerState();
}

class DateTimePickerSheerState extends State<DateTimePickerSheer> {
  late DateTime pickedDate;
  late final Function onDateTimeChanged;
  late String date;
  late String time;

  @override
  void initState() {
    super.initState();
    onDateTimeChanged = widget.onDateTimeChanged;
    date = getDateStringForDisplay(widget.initialDateTime);
     time = getTimeStringForDisplay(widget.initialDateTime);
    pickedDate = widget.initialDateTime;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        pickedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedDate.hour,
          pickedDate.minute,
        );
        date = getDateStringForDisplay(pickedDate);
        onDateTimeChanged(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(pickedDate),
    );
    if (picked != null) {
      setState(() {
        pickedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          picked.hour,
          picked.minute,
        );
        time = getTimeStringForDisplay(pickedDate);
        onDateTimeChanged(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            await _selectDate(context);
            if (context.mounted) await _selectTime(context);
          },
          child: const Text('Select Date and Time'),
        ),
        Text(date),
        Text(time),
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
    firstDate: DateTime(2021),
    lastDate: DateTime(2025),
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
