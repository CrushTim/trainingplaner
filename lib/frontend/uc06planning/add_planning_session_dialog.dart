import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class AddPlanningSessionDialog extends StatefulWidget {
  final DateTime initialDate;
  final String cycleId;

  const AddPlanningSessionDialog({
    super.key,
    required this.initialDate,
    required this.cycleId,
  });

  @override
  State<AddPlanningSessionDialog> createState() => _AddPlanningSessionDialogState();
}

class _AddPlanningSessionDialogState extends State<AddPlanningSessionDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emphasisController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    lengthController.text = "60"; // Default session length
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrainingSessionProvider>(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Session Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: emphasisController,
              decoration: const InputDecoration(labelText: 'Emphasis (comma separated)'),
            ),
            TextField(
              controller: lengthController,
              decoration: const InputDecoration(labelText: 'Length (minutes)'),
              keyboardType: TextInputType.number,
            ),
            DatePickerSheer(
              initialDateTime: selectedDate,
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  selectedDate = newDateTime;
                });
              },
              dateController: TextEditingController(text: selectedDate.toString()),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final session = TrainingSessionBus(
                      trainingSessionId: "",
                      isPlanned: true,
                      trainingSessionName: nameController.text,
                      trainingSessionDescription: descriptionController.text,
                      trainingSessionEmphasis: emphasisController.text.split(',').map((e) => e.trim()).toList(),
                      trainingSessionExcercisesIds: [],
                      trainingSessionLength: int.tryParse(lengthController.text) ?? 60,
                      trainingSessionStartDate: selectedDate,
                      trainingCycleId: widget.cycleId,
                    );

                    await provider.addBusinessClass(
                      session,
                      ScaffoldMessenger.of(context),
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
    );
  }
} 