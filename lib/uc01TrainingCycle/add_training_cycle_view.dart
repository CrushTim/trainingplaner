import 'package:flutter/material.dart';
import 'package:trainingplaner/uc01TrainingCycle/training_cycle_edit_fields.dart';

class AddTrainingCycleView extends StatefulWidget {
  const AddTrainingCycleView({super.key});

  @override
  State<AddTrainingCycleView> createState() => _AddTrainingCycleViewState();
}

class _AddTrainingCycleViewState extends State<AddTrainingCycleView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emphasisController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Training Cycle"),
      ),
      body: TrainingCycleEditFields(
          nameController: _nameController,
          descriptionController: _descriptionController,
          emphasisController: _emphasisController),
    );
  }
}
