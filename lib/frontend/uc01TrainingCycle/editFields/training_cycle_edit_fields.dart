import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/editFields/training_cycle_edit_fields_controller.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';

class TrainingCycleEditFields extends StatefulWidget {
  const TrainingCycleEditFields({super.key});

  @override
  State<TrainingCycleEditFields> createState() => _TrainingCycleEditFieldsState();
}

class _TrainingCycleEditFieldsState extends State<TrainingCycleEditFields> {
  late TrainingCycleEditFieldsController controller;

  @override
  void initState() {
    super.initState();
    controller = TrainingCycleEditFieldsController(
      Provider.of<TrainingCycleProvider>(context, listen: false)
    );
    controller.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.getTitle()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => controller.handleTextFieldChange('name', value),
              ),
              TextField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => controller.handleTextFieldChange('description', value),
              ),
              TextField(
                controller: controller.emphasisController,
                decoration: const InputDecoration(labelText: 'Emphasis'),
                onChanged: (value) => controller.handleTextFieldChange('emphasis', value),
              ),
              DropdownButtonFormField<String>(
                value: controller.getCurrentParentValue(),
                decoration: const InputDecoration(labelText: 'Parent Cycle'),
                items: controller.getParentDropdownItems(),
                onChanged: (value) => controller.updateParent(value),
              ),
              const SizedBox(height: 24),
              DatePickerSheer(
                onDateTimeChanged: (date) {
                  setState(() {
                    controller.onStartDateChanged(date);
                  });
                },
                initialDateTime: controller.startDate,
                dateController: controller.startDateController,
              ),
              DatePickerSheer(
                onDateTimeChanged: (date) {
                  setState(() {
                    controller.onEndDateChanged(date);
                  });
                },
                initialDateTime: controller.endDate,
                dateController: controller.endDateController,
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.saveTrainingCycle(ScaffoldMessenger.of(context));
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
