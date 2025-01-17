import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class PlanningWeekEditColumnController {
  final PlanningProvider planningProvider;
  final List<dynamic> weekSessions;
  final int copiedWeek;

  final TextEditingController percentageController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  PlanningWeekEditColumnController({
    required this.planningProvider,
    required this.weekSessions,
    required this.copiedWeek,
  });

  void handleParameterAdjustment(BuildContext context) {
    int percentageChange = int.tryParse(percentageController.text) ?? 0;
    int setChange = int.tryParse(setsController.text) ?? 0;
    int repChange = int.tryParse(repsController.text) ?? 0;
    
    planningProvider.adjustWeekExercisesParameters(
      weekSessions.cast<TrainingSessionBus>(),
      percentageChange,
      setChange,
      repChange,
      ScaffoldMessenger.of(context),
    );
  }

  void handleDeload(BuildContext context) {
    planningProvider.deloadWeekSessions(
      weekSessions.cast<TrainingSessionBus>(),
      copiedWeek,
      context,
    );
  }

  void handleCopyWeek(BuildContext context) {
    planningProvider.storeWeekSessions(
      weekSessions.cast<TrainingSessionBus>(),
      copiedWeek,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Week copied')),
    );
  }

  void handleInsertWeek(BuildContext context) {
    planningProvider.insertWeekSessions(
      copiedWeek,
      ScaffoldMessenger.of(context),
    );
    planningProvider.copiedSessions.clear();
  }

  bool get canInsertWeek => planningProvider.copiedSessions.isNotEmpty;

  void dispose() {
    percentageController.dispose();
    setsController.dispose();
    repsController.dispose();
  }
} 