import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/editFields/exercise_foundation_edit_fields.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';

class ExerciseFoundationListTileController {
  final ExerciseFoundationProvider provider;

  ExerciseFoundationListTileController(this.provider);

  /// Sorts the one rep maxes in descending order by date
  /// @param exerciseFoundation: The exercise foundation to sort
  /// @return: void
  void sortOneRepMaxes(ExerciseFoundationBus exerciseFoundation) {
    exerciseFoundation.userSpecific1RepMaxes.sort((a, b) {
      return b.date.compareTo(a.date);
    });
  }

  /// Gets the latest one rep max value or returns "-" if none exists
  /// @param exerciseFoundation: The exercise foundation to get the one rep max from
  /// @return: String
  String getLatestOneRepMax(ExerciseFoundationBus exerciseFoundation) {
    return exerciseFoundation.userSpecific1RepMaxes.isNotEmpty 
      ? exerciseFoundation.userSpecific1RepMaxes.first.oneRepMax.toString() 
      : " - ";
  }

  /// Opens the edit view for the exercise foundation
  /// @param context: The build context
  /// @param exerciseFoundation: The exercise foundation to edit
  /// @return: void
  void openEditView(BuildContext context, ExerciseFoundationBus exerciseFoundation) {
    provider.setSelectedBusinessClass(exerciseFoundation);
    provider.userSpecificExercise = exerciseFoundation.userSpecific1RepMaxes;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: provider,
          child: const ExerciseFoundationEditFields(),
        ),
      ),
    );
  }
} 