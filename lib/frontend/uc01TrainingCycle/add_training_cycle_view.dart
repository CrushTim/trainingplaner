import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_edit_fields.dart';

class AddTrainingCycleView extends StatefulWidget {
  const AddTrainingCycleView({super.key});

  @override
  State<AddTrainingCycleView> createState() => _AddTrainingCycleViewState();
}

class _AddTrainingCycleViewState extends State<AddTrainingCycleView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Training Cycle"),
      ),
      body: const TrainingCycleEditFields(),
    );
  }
}
