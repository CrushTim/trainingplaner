import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/editFields/add_exercise_edit_fields_controller.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class AddExerciseEditFields extends StatefulWidget {
  final bool addPlanned;
  const AddExerciseEditFields({super.key, this.addPlanned = false});

  @override
  State<AddExerciseEditFields> createState() => _AddExerciseEditFieldsState();
}

class _AddExerciseEditFieldsState extends State<AddExerciseEditFields> {
  late AddExerciseEditFieldsController controller;

  @override
  void initState() {
    super.initState();
    final provider = widget.addPlanned == false 
      ? Provider.of<TrainingSessionProvider>(context, listen: false).exerciseProvider 
      : Provider.of<PlanningProvider>(context, listen: false).exerciseProvider;
    
    controller = AddExerciseEditFieldsController(provider, addPlanned: widget.addPlanned);
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(controller.getTitleText()),
            TextField(
              controller: controller.exerciseNameController,
              decoration: const InputDecoration(labelText: 'Exercise Name'),
              onChanged: (value) => controller.handleFieldChange('name', value),
            ),
            TextField(
              controller: controller.exerciseDescriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => controller.handleFieldChange('description', value),
            ),
            TextField(
              controller: controller.targetPercentageController,
              decoration: const InputDecoration(labelText: 'Target Percentage of 1RM'),
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.handleFieldChange('targetPercentage', value),
            ),
            ElevatedButton(
              onPressed: () async {
                await controller.saveExercise(ScaffoldMessenger.of(context));
                if (context.mounted) {
                  Navigator.of(context).pop(controller.getTargetExercise());
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}