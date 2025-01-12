import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_exercise_provider.dart';

class AddExerciseEditFieldsController {
  final TrainingExerciseProvider provider;
  final bool addPlanned;
  
  final TextEditingController exerciseNameController = TextEditingController();
  final TextEditingController exerciseDescriptionController = TextEditingController();
  final TextEditingController targetPercentageController = TextEditingController();

  AddExerciseEditFieldsController(this.provider, {this.addPlanned = false});

  /// Initialize the controller state
  /// @return: void
  void initState() {
    TrainingExerciseBus target = provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
    if (addPlanned) {
      target.isPlanned = true;
    }
    if (provider.getSelectedBusinessClass != null) {
      exerciseNameController.text = target.exerciseName;
      exerciseDescriptionController.text = target.exerciseDescription;
      targetPercentageController.text = target.targetPercentageOf1RM.toString();
    }
  }

  /// Get the target exercise for editing
  /// @return: TrainingExerciseBus
  TrainingExerciseBus getTargetExercise() {
    return provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
  }

  /// Handle text field changes
  /// @param field: The field that changed
  /// @param value: The new value
  /// @return: void
  void handleFieldChange(String field, String value) {
    TrainingExerciseBus target = provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
    if (field == 'name') {
      target.exerciseName = value;
    } else if (field == 'description') {
      target.exerciseDescription = value;
    } else if (field == 'targetPercentage') {
      target.targetPercentageOf1RM = int.tryParse(value) ?? 100;
    }
  }

  /// Save the exercise
  /// @param scaffoldMessengerState: The scaffold messenger state
  /// @return: Future<void>
  Future<void> saveExercise(ScaffoldMessengerState scaffoldMessengerState) async {
    if (provider.getSelectedBusinessClass != null) {
      await provider.updateBusinessClass(
        provider.getSelectedBusinessClass!, 
        scaffoldMessengerState
      );
    } else {
      await provider.addBusinessClass(
        provider.businessClassForAdd, 
        scaffoldMessengerState
      );
    }
  }

  /// Get the title text for the dialog
  /// @return: String
  String getTitleText() {
    return provider.getSelectedBusinessClass == null ? "Add Exercise" : "Edit Exercise";
  }

  /// Clean up after dialog closes
  /// @return: void
  void dispose() {
    // Add any cleanup logic if needed
  }
} 