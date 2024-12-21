import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class AddWorkoutDialog extends StatefulWidget {
  const AddWorkoutDialog({super.key});

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<AddWorkoutDialog> {

  TextEditingController startDateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Reset the business class for add when dialog opens
    Provider.of<TrainingSessionProvider>(context, listen: false)
      ..resetBusinessClassForAdd()
      ..resetSessionControllers();
      startDateController.text = DateTime.now().toString();

  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrainingSessionProvider>(context);
    

    DateTime startDate = provider.selectedSessionDate;
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: provider.sessionNameController,
                decoration: const InputDecoration(labelText: 'Session Name'),
                onChanged: (value) => provider.handleSessionFieldChangeForAdd('name', value),
              ),
              TextField(
                controller: provider.sessionDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => provider.handleSessionFieldChangeForAdd('description', value),
              ),
              TextField(
                controller: provider.sessionEmphasisController,
                decoration: const InputDecoration(labelText: 'Emphasis (comma separated)'),
                onChanged: (value) => provider.handleSessionFieldChangeForAdd('emphasis', value),
              ),
              TextField(
                controller: provider.sessionLengthController,
                decoration: const InputDecoration(labelText: 'Length (minutes)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => provider.handleSessionFieldChangeForAdd('length', value),
              ),


              DropdownButtonFormField<String>(
          value: provider.businessClassForAdd.trainingCycleId.isEmpty ? null : provider.businessClassForAdd.trainingCycleId,
          decoration: const InputDecoration(labelText: 'Parent Cycle'),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('No Parent'),
            ),
            ...provider.allCycles.map((cycle) => DropdownMenuItem<String>(
              value: cycle.getId(),
              child: Text(cycle.cycleName),
            )),
          ],
          onChanged: (value) {
            setState(() {
              provider.businessClassForAdd.trainingCycleId = value ?? '';
              provider.handleSessionFieldChangeForAdd('cycle', value ?? '');
            });
          },
        ),

         DatePickerSheer(
          initialDateTime: startDate,
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() {
              startDate = newDateTime;
              provider.selectedSessionDate = newDateTime;
              startDateController.text = startDate.toString();
            });
          },
          dateController: startDateController,
        ),


              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      provider.resetBusinessClassForAdd();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await provider.addBusinessClass(
                        provider.businessClassForAdd,
                        ScaffoldMessenger.of(context),
                        notify: false
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
