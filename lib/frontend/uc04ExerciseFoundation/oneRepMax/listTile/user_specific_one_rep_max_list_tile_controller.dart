import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/oneRepMax/editFields/user_specific_one_rep_max_edit_fields.dart';

class UserSpecificOneRepMaxListTileController {
  final ExerciseFoundationProvider provider;

  UserSpecificOneRepMaxListTileController(this.provider);

  /// Opens the edit dialog for a one rep max entry
  /// @param context: The build context
  /// @param userSpecificExercise: The exercise to edit
  /// @return: Future<void>
  Future<void> openEditDialog(BuildContext context, UserSpecificExerciseBus userSpecificExercise) async {
    provider.setSelectedUserSpecificExercise(userSpecificExercise);
    provider.initialDateTimeOneRepMax = userSpecificExercise.date;
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserSpecificOneRepMaxEditFields(
              userSpecificExercise: userSpecificExercise
            ),
          ],
        ),
      ),
    ).then((_) {
      if (_ == true) {
        provider.userSpecificExercise.add(provider.userSpecificExerciseBusForAdd);
      }
      resetAfterDialog();
    });
  }

  /// Resets all necessary provider states after dialog closes
  void resetAfterDialog() {
    provider.resetUserSpecificExerciseForAdd();
    provider.resetSelectedUserSpecificExercise();
    provider.resetDateTimeOneRepMax();
  }

  /// Deletes a one rep max entry
  /// @param exercise: The exercise to delete
  /// @param scaffoldMessengerState: The scaffold messenger state
  void deleteOneRepMax(UserSpecificExerciseBus exercise, ScaffoldMessengerState scaffoldMessengerState) {
    provider.deleteUserSpecificExerciseAndUpdateList(exercise, scaffoldMessengerState);
  }
} 