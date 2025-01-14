import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class AddPlanningExerciseTileController {
  final PlanningProvider provider;
  bool isExpanded = false;

  AddPlanningExerciseTileController(this.provider);

  /// Toggles the expanded state of the exercise tile
  void toggleExpanded() {
    isExpanded = !isExpanded;
  }

  /// Gets the appropriate icon based on expansion state
  IconData getArrowIcon() {
    return isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down;
  }

  /// Updates the reps and weight for a specific set
  /// @param exercise: The exercise to update
  /// @param index: The index of the set to update
  /// @param reps: The new number of reps
  /// @param weight: The new weight
  void updateRepsAndWeight(TrainingExerciseBus exercise, int index, int reps, double weight) {
    exercise.exerciseReps[index] = reps;
    exercise.exerciseWeights[index] = weight;
  }

  /// Deletes a specific set from the exercise
  /// @param exercise: The exercise to update
  /// @param index: The index of the set to delete
  void deleteRepsAndWeight(TrainingExerciseBus exercise, int index) {
    exercise.exerciseReps.removeAt(index);
    exercise.exerciseWeights.removeAt(index);
  }

  /// Adds a new set to the exercise
  /// @param exercise: The exercise to update
  void addNewSet(TrainingExerciseBus exercise) {
    if (exercise.exerciseWeights.isNotEmpty) {
      // Copy values from the last set
      exercise.exerciseWeights.add(
        exercise.exerciseWeights[exercise.exerciseWeights.length - 1]
      );
      exercise.exerciseReps.add(
        exercise.exerciseReps[exercise.exerciseReps.length - 1]
      );
    } else {
      // Add default values for first set
      exercise.exerciseWeights.add(0);
      exercise.exerciseReps.add(0);
    }
  }

  /// Gets the display text for the exercise
  /// @param exercise: The exercise to get the display text for
  /// @return: The display text
  String getExerciseDisplayText(TrainingExerciseBus exercise) {
    return exercise.exerciseName;
  }

  /// Gets the foundation ID text for the exercise
  /// @param exercise: The exercise to get the foundation ID for
  /// @return: The foundation ID text
  String getExerciseFoundationID(TrainingExerciseBus exercise) {
    return exercise.exerciseFoundationID;
  }

  /// Updates an exercise in the provider
  /// @param exercise: The exercise to update
  /// @param scaffoldMessenger: The scaffold messenger for showing snackbars
  Future<void> handleExerciseUpdate(
    TrainingExerciseBus exercise,
    ScaffoldMessengerState scaffoldMessenger
  ) async {
    await provider.exerciseProvider.updateBusinessClass(
      exercise,
      scaffoldMessenger
    );
  }

  /// Deletes an exercise from the provider
  /// @param exercise: The exercise to delete
  /// @param scaffoldMessenger: The scaffold messenger for showing snackbars
  Future<void> handleExerciseDelete(
    TrainingExerciseBus exercise,
    ScaffoldMessengerState scaffoldMessenger
  ) async {
    await provider.exerciseProvider.deleteBusinessClass(
      exercise,
      scaffoldMessenger,
      notify: false
    );
  }
} 