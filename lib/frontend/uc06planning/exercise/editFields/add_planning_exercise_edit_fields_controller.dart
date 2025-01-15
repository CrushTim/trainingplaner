import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class AddPlanningExerciseEditFieldsController {
  final PlanningProvider provider;
  
  final TextEditingController exerciseNameController = TextEditingController();
  final TextEditingController exerciseDescriptionController = TextEditingController();
  final TextEditingController targetPercentageController = TextEditingController();

  AddPlanningExerciseEditFieldsController(this.provider);

  void initState() {
    TrainingExerciseBus target = provider.exerciseProvider.getSelectedBusinessClass ?? 
                                provider.exerciseProvider.businessClassForAdd;
    
    target.isPlanned = true;
    
    if (provider.exerciseProvider.getSelectedBusinessClass != null) {
      exerciseNameController.text = target.exerciseName;
      exerciseDescriptionController.text = target.exerciseDescription;
      targetPercentageController.text = target.targetPercentageOf1RM.toString();
    } else {
      exerciseNameController.clear();
      exerciseDescriptionController.clear();
      targetPercentageController.text = "0";
    }
  }

  void handleFieldChange(String field, String value) {
    final target = provider.exerciseProvider.businessClassForAdd;
    
    switch (field) {
      case 'name':
        target.exerciseName = value;
        break;
      case 'description':
        target.exerciseDescription = value;
        break;
      case 'targetPercentage':
        target.targetPercentageOf1RM = int.tryParse(value) ?? 0;
        break;
    }
  }

  String getTitleText() {
    return provider.exerciseProvider.getSelectedBusinessClass == null 
        ? "Add Exercise" 
        : "Edit Exercise";
  }

  Future<void> handleSave(BuildContext context, ScaffoldMessengerState scaffoldMessenger) async {
    final exercise = provider.exerciseProvider.businessClassForAdd;
    
    if (exercise.exerciseName.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Please enter an exercise name'))
      );
      return;
    }

    if (provider.exerciseProvider.getSelectedBusinessClass != null) {
      await provider.exerciseProvider.updateBusinessClass(
        provider.exerciseProvider.getSelectedBusinessClass!,
        scaffoldMessenger
      );
    } else {
      await provider.exerciseProvider.addBusinessClass(
        provider.exerciseProvider.businessClassForAdd,
        scaffoldMessenger
      );
    }

    if (context.mounted) {
      Navigator.pop(context, exercise);
    }
  }

  void dispose() {
    exerciseNameController.dispose();
    exerciseDescriptionController.dispose();
    targetPercentageController.dispose();
  }
} 