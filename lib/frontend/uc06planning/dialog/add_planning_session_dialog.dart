import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc06planning/dialog/add_planning_session_dialog_controller.dart';
import 'package:trainingplaner/frontend/uc06planning/exercise/addexerciseDialog/add_planning_session_edit_fields.dart';
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
  late AddPlanningSessionDialogController controller;

  @override
  void initState() {
    super.initState();
    controller = AddPlanningSessionDialogController(
      Provider.of<PlanningProvider>(context, listen: false),
      widget.cycleId,
      widget.initialDate
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
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.getTitleText()),
              const SizedBox(height: 16),
              const AddPlanningSessionEditFields(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => controller.handleCancel(
                      context,
                      ScaffoldMessenger.of(context)
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.saveSession(
                      context,
                      ScaffoldMessenger.of(context)
                    ),
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