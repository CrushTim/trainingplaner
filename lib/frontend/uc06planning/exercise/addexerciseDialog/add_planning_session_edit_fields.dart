import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc06planning/exercise/addexerciseDialog/add_planning_session_edit_fields_controller.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class AddPlanningSessionEditFields extends StatefulWidget {
  const AddPlanningSessionEditFields({super.key});

  @override
  State<AddPlanningSessionEditFields> createState() => _AddPlanningSessionEditFieldsState();
}

class _AddPlanningSessionEditFieldsState extends State<AddPlanningSessionEditFields> {
  late AddPlanningSessionEditFieldsController controller;

  @override
  void initState() {
    super.initState();
    controller = AddPlanningSessionEditFieldsController(
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
      ],
    );
  }
} 