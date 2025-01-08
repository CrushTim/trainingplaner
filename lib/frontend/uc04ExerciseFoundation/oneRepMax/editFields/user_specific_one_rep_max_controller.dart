import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';

class UserSpecificOneRepMaxController {
  final ExerciseFoundationProvider provider;
  final TextEditingController oneRepMaxController = TextEditingController();
  DateTime initialDateTime = DateTime.now();

  UserSpecificOneRepMaxController(this.provider);

  /// Initialize the state of the controller
  /// Should be called when the state is initialized
  /// @return: void
  void initState() {
    if (provider.selectedUserSpecificExercise != null) {
      oneRepMaxController.text = provider.selectedUserSpecificExercise!.oneRepMax.toString();
      initialDateTime = provider.selectedUserSpecificExercise!.date;
    } else {
      oneRepMaxController.text = "";
    }
  }

  /// Handle the change of the text field
  /// @param: field - the field that is changed
  /// @param: value - the value of the field
  /// @return: void
  void handleTextFieldChange(String field, String value) {
    UserSpecificExerciseBus target = provider.selectedUserSpecificExercise ?? provider.userSpecificExerciseBusForAdd;
    switch (field) {
      case 'oneRepMax':
        target.oneRepMax = double.parse(value);
        break;
    }
  }

  /// Handle the change of the date time picker
  /// @param: dateTime - the date time that is selected
  /// @return: void
  void onDateTimeChanged(DateTime dateTime) {
    UserSpecificExerciseBus target = provider.selectedUserSpecificExercise ?? provider.userSpecificExerciseBusForAdd;
    target.date = dateTime;
    initialDateTime = dateTime;
  }

  /// Save the user specific exercise - if the exercise is already in the list, it will be updated, otherwise it will be added
  /// @param: scaffoldMessengerState - the scaffold messenger state
  /// @return: void
  Future<void> saveUserSpecificExercise(ScaffoldMessengerState scaffoldMessengerState) async {
    if (provider.selectedUserSpecificExercise != null) {
      await provider.updateUserSpecificExercise(provider.selectedUserSpecificExercise!, scaffoldMessengerState);
    } else {
      await provider.addUserSpecificExercise(provider.userSpecificExerciseBusForAdd, scaffoldMessengerState);
    }
  }

  /// Reset the user specific exercise for add and selected user specific exercise
  /// used after saving the user specific exercise
  /// @return: void
  void resetAfterSave() {
    provider.resetUserSpecificExerciseForAdd();
    provider.resetSelectedUserSpecificExercise();
    oneRepMaxController.clear();
    initialDateTime = DateTime.now();
  }

  /// After the dialog is closed, the user specific exercise is added to the list and the state is reset
  /// @param: result - the result of the dialog
  /// @return: void
  void afterDialogIsClosed(bool? result) {
    if (result == true) {
      provider.userSpecificExercise.add(provider.userSpecificExerciseBusForAdd);
    }
    resetAfterSave();
  }

  /// Delete the user specific exercise
  /// @param: exercise - the exercise that is deleted
  /// @param: scaffoldMessengerState - the scaffold messenger state
  /// @return: void
  void deleteUserSpecificExercise(UserSpecificExerciseBus exercise, ScaffoldMessengerState scaffoldMessengerState) {
    provider.deleteUserSpecificExercise(exercise, scaffoldMessengerState);
    provider.userSpecificExercise.remove(exercise);
  }

  /// Dispose the controller
  /// @return: void
  void dispose() {
    oneRepMaxController.dispose();
  }
} 