import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/add_training_cycle_view.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/cycle_draggable.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';

class EditCyclesView extends StatefulWidget {
  const EditCyclesView({super.key});

  @override
  State<EditCyclesView> createState() => _EditCyclesViewState();
}

class _EditCyclesViewState extends State<EditCyclesView> {
  
  @override
  Widget build(BuildContext context) {
    TrainingCycleProvider trainingCycleProvider = Provider.of<TrainingCycleProvider>(context);
    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Cycles"),
      ),
      body: trainingCycleProvider.getTrainingCycles(),
    );
  }
}
