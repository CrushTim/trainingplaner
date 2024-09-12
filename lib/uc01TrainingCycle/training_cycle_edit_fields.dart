import 'package:flutter/material.dart';
import 'package:trainingplaner/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/functions/functions_trainingsplaner.dart';

class TrainingCycleEditFields extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController emphasisController;

  const TrainingCycleEditFields(
      {super.key,
      required this.nameController,
      required this.descriptionController,
      required this.emphasisController});

  @override
  State<TrainingCycleEditFields> createState() =>
      _TrainingCycleEditFieldsState();
}

class _TrainingCycleEditFieldsState extends State<TrainingCycleEditFields> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _emphasisController;
  late DateTime _startDate;
  late DateTime _endDate;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();

    _nameController = widget.nameController;
    _descriptionController = widget.descriptionController;
    _emphasisController = widget.emphasisController;
    //TODO: start and end date from parent later
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _startDateController.text = getDateStringForDisplay(_startDate);
    _endDateController.text = getDateStringForDisplay(_endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
        ),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
        TextField(
          controller: _emphasisController,
          decoration: const InputDecoration(labelText: 'Emphasis'),
        ),
        DatePickerSheer(
          initialDateTime: _startDate,
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() {
              _startDate = newDateTime;
            });
          },
          dateController: _startDateController,
        ),
        DatePickerSheer(
          initialDateTime: _endDate,
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() {
              _endDate = newDateTime;
            });
          },
          dateController: _endDateController,
        ),
        //TODO: make dropdown select the existing training cycles
        //and make them selectable
        //when selected, the field should be filled with the name and the parent value of the selected cycle should be set to this cycleID
        DropdownMenu(
          width: MediaQuery.of(context).size.width,
          label: const Text("parent"),
          onSelected: (selected) {
            return null;
          },
          dropdownMenuEntries: [
            DropdownMenuEntry(value: "1", label: "alksd"),
            DropdownMenuEntry(value: "2", label: "parent")
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              //TODO: implement saving the training cycle
              //and navigate back to the previous view
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ),
      ],
    );
  }
}
