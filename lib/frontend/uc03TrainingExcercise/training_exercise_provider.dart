import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/reports/excercise_foundation_bus_report.dart';
import 'package:trainingplaner/business/reports/training_exercise_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';

class TrainingExerciseProvider extends TrainingsplanerProvider<TrainingExerciseBus, TrainingExerciseBusReport> {
  TrainingExerciseProvider()
      : super(
          businessClassForAdd: TrainingExerciseBus(
            trainingExerciseID: "",
            exerciseName: "",
            exerciseDescription: "",
            exerciseFoundationID: "",
            targetPercentageOf1RM: 100,
            exerciseReps: [],
            exerciseWeights: [],
            isPlanned: false,
            plannedExerciseId: "",
            date: DateTime.now(),
          ),
          reportTaskVar: TrainingExerciseBusReport(),
        );

  Map<TrainingExerciseBus, TrainingExerciseBus?> plannedToActualExercises = {};
  List<TrainingExerciseBus> unplannedExercisesForSession = [];
  List<TrainingExerciseBus> unplannedExercises = [];
  List<ExerciseFoundationBus> availableFoundations = [];

  final TextEditingController exerciseNameController = TextEditingController();
  final TextEditingController exerciseDescriptionController = TextEditingController();
  final TextEditingController targetPercentageController = TextEditingController();


  void resetAllExerciseLists() {
    plannedToActualExercises.clear();
    unplannedExercisesForSession.clear();
    unplannedExercises.clear();
    notifyListeners();
  }

  void handleExerciseFieldChange(String field, String value) {
    TrainingExerciseBus target = getSelectedBusinessClass ?? businessClassForAdd;
    switch (field) {
      case 'name':
        target.exerciseName = value;
        break;
      case 'description':
        target.exerciseDescription = value;
        break;
      case 'targetPercentage':
        target.targetPercentageOf1RM = int.tryParse(value) ?? 100;
        break;
    }
  }

  List<TrainingExerciseBus> getUnplannedExercisesForSession(TrainingSessionBus session) {
    return session.trainingSessionExercises.where((exercise) => 
      !plannedToActualExercises.containsValue(exercise)).toList();
  }

  ExerciseFoundationBusReport foundationReport = ExerciseFoundationBusReport();

  StreamBuilder getFoundationAutoComplete() {
    return StreamBuilder(
      stream: foundationReport.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          availableFoundations = snapshot.data!;
          return Autocomplete<ExerciseFoundationBus>(
            displayStringForOption: (ExerciseFoundationBus option) => 
              option.exerciseFoundationName,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<ExerciseFoundationBus>.empty();
              }
              return availableFoundations.where((foundation) {
                return foundation.exerciseFoundationName
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (ExerciseFoundationBus selection) {
              if (getSelectedBusinessClass != null) {
                getSelectedBusinessClass!.exerciseFoundationID = selection.getId();
              } else {
                businessClassForAdd.exerciseFoundationID = selection.getId();
              }
              notifyListeners();
            },
          );
        }
      },
    );
  }

  Future<void> updateExercises(
    List<TrainingExerciseBus> exercises,
    ScaffoldMessengerState scaffoldMessengerState, {
    bool notify = true,
  }) async {
    String message = "Exercises updated";
    try {
      for (var exercise in exercises) {
        await exercise.update().onError((error, stackTrace) {
          message = "Error updating ${exercise.exerciseName}: ${error.toString()}";
          throw error!;
        });
      }
    } catch (e) {
      message = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<List<String>> createExerciseCopies(List<TrainingExerciseBus> exercises, ScaffoldMessengerState scaffoldMessenger) async {
    List<String> newExerciseIds = [];
    String message = "Exercises copied successfully";

    try {
      for (var exercise in exercises) {
        // Create a new exercise with copied properties but empty ID
        TrainingExerciseBus exerciseCopy = TrainingExerciseBus(
          trainingExerciseID: "",
          exerciseName: exercise.exerciseName,
          exerciseDescription: exercise.exerciseDescription,
          exerciseFoundationID: exercise.exerciseFoundationID,
          exerciseReps: List<int>.from(exercise.exerciseReps),
          exerciseWeights: List<double>.from(exercise.exerciseWeights),
          date: exercise.date,
          isPlanned: exercise.isPlanned,
          targetPercentageOf1RM: exercise.targetPercentageOf1RM,
        );

        // Add the copy to database and get new ID
        String newId = await addBusinessClass(exerciseCopy, scaffoldMessenger, notify: false);
        newExerciseIds.add(newId);
      }
    } catch (e) {
      message = "Error copying exercises: ${e.toString()}";
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(message)),
      );
      rethrow;
    }

    return newExerciseIds;
  }

  Future<void> replaceSessionExerciseIds(
    TrainingSessionBus session,
    List<String> newExerciseIds,
    ScaffoldMessengerState scaffoldMessenger
  ) async {
    try {
      // Replace the exercise IDs in the session
      session.trainingSessionExcercisesIds = newExerciseIds;
      
      // Clear the exercises list as it will be repopulated when the session is loaded
      session.trainingSessionExercises.clear();
      
      // Update the session in the database
      await session.update();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Error updating session with new exercise IDs: ${e.toString()}")),
      );
      rethrow;
    }
  }

} 