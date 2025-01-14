import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc06planning/exercise/addexerciseDialog/add_planning_exercise_edit_fields_controller.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class AddPlanningExerciseEditFields extends StatefulWidget {
  const AddPlanningExerciseEditFields({super.key});

  @override
  State<AddPlanningExerciseEditFields> createState() => _AddPlanningExerciseEditFieldsState();
}

class _AddPlanningExerciseEditFieldsState extends State<AddPlanningExerciseEditFields> {
  late AddPlanningExerciseEditFieldsController controller;

  @override
  void initState() {
    super.initState();
    controller = AddPlanningExerciseEditFieldsController(
      Provider.of<PlanningProvider>(context, listen: false)
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
            decoration: const InputDecoration(labelText: 'Target Percentage'),
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.handleFieldChange('targetPercentage', value),
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
                onPressed: () => controller.handleSave(
                  context,
                  ScaffoldMessenger.of(context)
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 