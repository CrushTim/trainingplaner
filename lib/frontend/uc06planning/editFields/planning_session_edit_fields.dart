import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc06planning/editFields/planning_session_edit_fields_controller.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class PlanningSessionEditFields extends StatelessWidget {
  const PlanningSessionEditFields({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanningProvider>(context);
    final controller = PlanningSessionEditFieldsController(provider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller.sessionNameController,
          decoration: const InputDecoration(labelText: 'Session Name'),
          onChanged: (value) => controller.handleFieldChange('name', value),
        ),
        TextField(
          controller: controller.sessionDescriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
          onChanged: (value) => controller.handleFieldChange('description', value),
        ),
        TextField(
          controller: controller.sessionEmphasisController,
          decoration: const InputDecoration(labelText: 'Emphasis'),
          onChanged: (value) => controller.handleFieldChange('emphasis', value),
        ),
        TextField(
          controller: controller.sessionLengthController,
          decoration: const InputDecoration(labelText: 'Length (minutes)'),
          keyboardType: TextInputType.number,
          onChanged: (value) => controller.handleFieldChange('length', value),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => controller.openAddExerciseDialog(context),
          child: const Text("Add Exercise")
        ),
        ...controller.buildExerciseList(context),
      ],
    );
  }
} 