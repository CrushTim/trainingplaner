import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';

class PlanningView extends StatefulWidget {
  const PlanningView({super.key});

  @override
  State<PlanningView> createState() => _PlanningViewState();
}

class _PlanningViewState extends State<PlanningView> {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<TrainingCycleProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
      ),
      body: ListView(
        children: [
          cycleProvider.getTrainingCycles(planningMode: true),
        ],
      ),
    );
  }
}
