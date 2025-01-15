import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/uc06planning/exercise/addPlanningSessionTile/add_planning_session_edit_fields_controller.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class AddPlanningSessionDialogController {
  final PlanningProvider provider;
  final String cycleId;
  final DateTime initialDate;
  late AddPlanningSessionEditFieldsController editFieldsController;

  AddPlanningSessionDialogController(this.provider, this.cycleId, this.initialDate) {
    editFieldsController = AddPlanningSessionEditFieldsController(provider);
  }

  void initState() {
    editFieldsController.initState();
  }

  Future<void> saveSession(BuildContext context, ScaffoldMessengerState scaffoldMessengerState) async {
    if (provider.getSelectedBusinessClass != null) {
      await provider.updateSelectedBusinessClass(scaffoldMessengerState);
    } else {
      provider.businessClassForAdd.trainingCycleId = cycleId;
      provider.businessClassForAdd.trainingSessionStartDate = initialDate;
      await provider.addForAddBusinessClass(scaffoldMessengerState);
    }
    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void dispose() {
    editFieldsController.dispose();
  }

  String getTitleText() {
    return provider.getSelectedBusinessClass == null ? "Add Training Session" : "Edit Training Session";
  }

  void handleExerciseAdd(dynamic value) {
    if (value != null) {
      provider.exercisesToDeleteIfSessionAddIsCancelled.add(value);
    }
    provider.exerciseProvider.resetBusinessClassForAdd();
  }

  void handleCancel(BuildContext context, ScaffoldMessengerState scaffoldMessenger) {
    for (var exercise in provider.exercisesToDeleteIfSessionAddIsCancelled) {
      provider.exerciseProvider.deleteBusinessClass(
        exercise,
        scaffoldMessenger,
        notify: false
      );
    }
    Navigator.pop(context);
  }
} 