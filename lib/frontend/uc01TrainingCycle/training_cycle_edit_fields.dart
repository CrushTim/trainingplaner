import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';

class TrainingCycleEditFields extends StatefulWidget {
  const TrainingCycleEditFields({super.key});

  @override
  State<TrainingCycleEditFields> createState() => _TrainingCycleEditFieldsState();
}

class _TrainingCycleEditFieldsState extends State<TrainingCycleEditFields> {

  @override
  void initState() {
    super.initState();
    Provider.of<TrainingCycleProvider>(context, listen: false).initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrainingCycleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Cycle"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: provider.nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => provider.handleTextFieldChange('name', value),
              ),
              TextField(
                controller: provider.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => provider.handleTextFieldChange('description', value),
              ),
              TextField(
                controller: provider.emphasisController,
                decoration: const InputDecoration(labelText: 'Emphasis'),
                onChanged: (value) => provider.handleTextFieldChange('emphasis', value),
              ),
              const SizedBox(height: 16),
              DatePickerSheer(
                initialDateTime: provider.startDate,
                onDateTimeChanged: provider.updateStartDate,
                dateController: provider.startDateController,
              ),
              const SizedBox(height: 16),
              DatePickerSheer(
                initialDateTime: provider.endDate,
                onDateTimeChanged: provider.updateEndDate,
                dateController: provider.endDateController,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: provider.selectedParentId,
                decoration: const InputDecoration(labelText: 'Parent Cycle'),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('No Parent'),
                  ),
                  ...provider.parentCycles.map((cycle) => DropdownMenuItem<String>(
                    value: cycle.getId(),
                    child: Text(cycle.cycleName),
                  )),
                ],
                onChanged: (value) => provider.updateParent(value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  provider.saveTrainingCycle(ScaffoldMessenger.of(context));
                  Navigator.pop(context);
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
