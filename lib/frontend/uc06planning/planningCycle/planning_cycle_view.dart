import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_exercise_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class PlanningCycleView extends StatefulWidget {
  final TrainingCycleBus cycle;
  
  const PlanningCycleView({
    super.key,
    required this.cycle,
  });

  @override
  State<PlanningCycleView> createState() => _PlanningCycleViewState();
}

class _PlanningCycleViewState extends State<PlanningCycleView> {

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<TrainingSessionProvider>(context);
    final cycleProvider = Provider.of<TrainingCycleProvider>(context);
    final planningProvider = Provider.of<PlanningProvider>(context);
    final exerciseProvider = Provider.of<TrainingExerciseProvider>(context);
    cycleProvider.setSelectedBusinessClass(widget.cycle, notify: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Planning: ${widget.cycle.cycleName}'),
      ),
      body: cycleProvider.getPlanningStreamBuilder(sessionProvider, exerciseProvider, planningProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  
} 