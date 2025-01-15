import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class AddPlanningSessionEditFieldsController {
  final PlanningProvider provider;
  final TextEditingController sessionNameController;
  final TextEditingController sessionDescriptionController;
  final TextEditingController sessionEmphasisController;
  final TextEditingController sessionLengthController;

  AddPlanningSessionEditFieldsController(this.provider)
      : sessionNameController = provider.sessionNameController,
        sessionDescriptionController = provider.sessionDescriptionController,
        sessionEmphasisController = provider.sessionEmphasisController,
        sessionLengthController = provider.sessionLengthController;

  void initState() {
    final target = provider.getSelectedBusinessClass;
    if (target != null) {
      sessionNameController.text = target.trainingSessionName;
      sessionDescriptionController.text = target.trainingSessionDescription;
      sessionEmphasisController.text = target.trainingSessionEmphasis.join(', ');
      sessionLengthController.text = target.trainingSessionLength.toString();
      provider.selectedSessionDate = target.trainingSessionStartDate;
    } else {
      resetSessionControllers();
    }
  }

  void handleFieldChange(String field, String value) {
    final target = provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
    switch (field) {
      case 'name':
        target.trainingSessionName = value;
        break;
      case 'description':
        target.trainingSessionDescription = value;
        break;
      case 'emphasis':
        target.trainingSessionEmphasis = value.split(',').map((e) => e.trim()).toList();
        break;
      case 'length':
        target.trainingSessionLength = int.tryParse(value) ?? 60;
        break;
    }
  }

  void updateSessionDate(DateTime date) {
    provider.selectedSessionDate = date;
    final target = provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
    target.trainingSessionStartDate = date;
  }

  void resetSessionControllers() {
    sessionNameController.clear();
    sessionDescriptionController.clear();
    sessionEmphasisController.clear();
    sessionLengthController.text = "60";
    provider.selectedSessionDate = DateTime.now();
  }

  void dispose() {
    // Controllers are owned by the provider, so we don't dispose them here
  }
} 