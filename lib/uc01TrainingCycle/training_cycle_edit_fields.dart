import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

    _nameController = widget.nameController;
    _descriptionController = widget.descriptionController;
    _emphasisController = widget.emphasisController;
    //TODO: start and end date from parent later
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
        TextField(
          controller: _emphasisController,
          decoration: const InputDecoration(labelText: 'Emphasis'),
        ),
        Row(
          children: [
            Text('Start Date: ${_startDate.toIso8601String()}'),
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _startDate = value;
                    });
                  }
                });
              },
              child: const Text('Change'),
            ),
          ],
        ),
        Row(
          children: [
            Text('End Date: ${_endDate.toIso8601String()}'),
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _endDate = value;
                    });
                  }
                });
              },
              child: const Text('Change'),
            ),
          ],
        ),
      ],
    );
  }
}
