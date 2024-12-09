import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

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
  @override
  void initState() {
    super.initState();
    PlanningProvider provider = Provider.of<PlanningProvider>(context, listen: false);
    provider.selectedSessionDate = widget.initialDate;
    provider.initControllersForPlanningView();
    print("xxxx");
    print(provider.selectedSessionDate);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanningProvider>(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: provider.sessionNameController,
              decoration: const InputDecoration(labelText: 'Session Name'),
              onChanged: (value) => provider.handleSessionFieldChangeForPlanned('name', value),
            ),
            TextField(
              controller: provider.sessionDescriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => provider.handleSessionFieldChangeForPlanned('description', value),
            ),
            TextField(
              controller: provider.sessionEmphasisController,
              decoration: const InputDecoration(labelText: 'Emphasis (comma separated)'),
              onChanged: (value) => provider.handleSessionFieldChangeForPlanned('emphasis', value),
            ),
            TextField(
              controller: provider.sessionLengthController,
              decoration: const InputDecoration(labelText: 'Length (minutes)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => provider.handleSessionFieldChangeForPlanned('length', value),
            ),
            DatePickerSheer(
              initialDateTime: provider.selectedSessionDate,
              onDateTimeChanged: provider.updateSessionDate,
              dateController: TextEditingController(
                text: provider.selectedSessionDate.toString()
              ),
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
                  onPressed: () {
                    if (provider.getSelectedBusinessClass != null) {
                      provider.getSelectedBusinessClass!.trainingCycleId = widget.cycleId;
                    } else {
                      provider.businessClassForAdd.trainingCycleId = widget.cycleId;
                    }
                    provider.saveSession(context);
                  },
                  child: Text(provider.getSelectedBusinessClass != null ? 'Update' : 'Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 