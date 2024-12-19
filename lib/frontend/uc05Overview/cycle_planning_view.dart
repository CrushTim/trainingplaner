import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExercise/training_exercise_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class CyclePlanningView extends StatefulWidget {
  final TrainingCycleBus cycle;
  
  const CyclePlanningView({
    super.key,
    required this.cycle,
  });

  @override
  State<CyclePlanningView> createState() => _CyclePlanningViewState();
}

class _CyclePlanningViewState extends State<CyclePlanningView> {

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<TrainingSessionProvider>(context);
    final cycleProvider = Provider.of<TrainingCycleProvider>(context);
    final planningProvider = Provider.of<PlanningProvider>(context);
    final exerciseProvider = Provider.of<TrainingExerciseProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Planning: ${widget.cycle.cycleName}'),
      ),
      body: cycleProvider.getPlanningStreamBuilder(sessionProvider, exerciseProvider, widget.cycle, planningProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  
} 