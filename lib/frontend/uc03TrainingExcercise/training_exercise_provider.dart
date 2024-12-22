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

} 