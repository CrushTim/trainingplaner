import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/services/connectivity_service.dart';

class WorkoutViewEditFieldsController {
  final TrainingSessionProvider trainingSessionProvider;
  final ConnectivityService connectivityService = ConnectivityService();
  bool isOnlinee = false;

  WorkoutViewEditFieldsController(this.trainingSessionProvider) {
    isOnlinee = connectivityService.isConnected;
    connectivityService.connectionStream.listen((bool isOnline) {
      isOnlinee = isOnline;
    });
  }

  void initState() {
    if(trainingSessionProvider.selectedActualSession != null) {
      final session = trainingSessionProvider.selectedActualSession!;
      trainingSessionProvider.selectedSessionDate = session.trainingSessionStartDate;
    }
  }

  Future<void> handleReorder(int oldIndex, int newIndex, BuildContext context) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    
    final session = trainingSessionProvider.selectedActualSession!;
    
    // Get all exercises in their current order
    final allExercises = [
      ...getOrderedExercises(trainingSessionProvider, true),
      ...getOrderedExercises(trainingSessionProvider, false)
    ];
    final exerciseToMove = allExercises[oldIndex];
    
    // Update the IDs list
    if (oldIndex < session.trainingSessionExcercisesIds.length) {
      final exerciseId = session.trainingSessionExcercisesIds.removeAt(oldIndex);
      session.trainingSessionExcercisesIds.insert(
        newIndex < session.trainingSessionExcercisesIds.length ? newIndex : session.trainingSessionExcercisesIds.length,
        exerciseId
      );
    }

    // Update the actual session's exercises list
    if (oldIndex < session.trainingSessionExercises.length) {
      final actualExercise = session.trainingSessionExercises.removeAt(oldIndex);
      session.trainingSessionExercises.insert(
        newIndex < session.trainingSessionExercises.length ? newIndex : session.trainingSessionExercises.length,
        actualExercise
      );

      // If offline, ensure the moved exercise is in tempExercises
      if (!isOnlinee && !trainingSessionProvider.tempExercises.contains(actualExercise)) {
        trainingSessionProvider.tempExercises.add(actualExercise);
      }
    }

    // Update the planned exercises list if it exists and the exercise is planned
    if (trainingSessionProvider.getSelectedBusinessClass != null && 
        trainingSessionProvider.getSelectedBusinessClass!.trainingSessionExercises.contains(exerciseToMove)) {
      final plannedIndex = trainingSessionProvider.getSelectedBusinessClass!.trainingSessionExercises
          .indexOf(exerciseToMove);
      final exercise = trainingSessionProvider.getSelectedBusinessClass!.trainingSessionExercises
          .removeAt(plannedIndex);
      trainingSessionProvider.getSelectedBusinessClass!.trainingSessionExercises
          .insert(newIndex, exercise);
    }
    
    // Update unplanned exercises list if necessary
    if (trainingSessionProvider.exerciseProvider.unplannedExercisesForSession.contains(exerciseToMove)) {
      final unplannedIndex = trainingSessionProvider.exerciseProvider.unplannedExercisesForSession
          .indexOf(exerciseToMove);
      final exercise = trainingSessionProvider.exerciseProvider.unplannedExercisesForSession
          .removeAt(unplannedIndex);
      trainingSessionProvider.exerciseProvider.unplannedExercisesForSession
          .insert(newIndex, exercise);
    }

    if (isOnlinee) {
      await trainingSessionProvider.updateBusinessClass(
        session, 
        ScaffoldMessenger.of(context), 
        notify: false
      );
    }
  }

  List<TrainingExerciseBus> getOrderedExercises(
      TrainingSessionProvider provider,
      bool planned) {
    final session = provider.selectedActualSession!;
    final List<TrainingExerciseBus?> orderedExercises = List.filled(
      session.trainingSessionExcercisesIds.length,
      null
    );
    
    if (planned) {
      if (provider.getSelectedBusinessClass?.trainingSessionExercises != null) {
        final exercises = provider.getSelectedBusinessClass!.trainingSessionExercises;
        for (int i = 0; i < session.trainingSessionExcercisesIds.length; i++) {
          final id = session.trainingSessionExcercisesIds[i];
          try {
            final exercise = exercises.firstWhere((e) => e.trainingExerciseID == id);
            orderedExercises[i] = exercise;
          } catch (e) {
            continue;
          }
        }
      }
    } else {
      final exercises = [
        ...provider.exerciseProvider.unplannedExercisesForSession,
        ...provider.tempExercises
      ];
      
      for (int i = 0; i < session.trainingSessionExcercisesIds.length; i++) {
        final id = session.trainingSessionExcercisesIds[i];
        try {
          final exercise = exercises.firstWhere((e) => e.trainingExerciseID == id);
          orderedExercises[i] = exercise;
        } catch (e) {
          continue;
        }
      }
    }

    return orderedExercises.whereType<TrainingExerciseBus>().toList();
  }

  Future<void> handlePlannedExerciseUpdate(
    dynamic exercise, 
    dynamic actualExercise, 
    ScaffoldMessengerState scaffoldMessenger
  ) async {
    if (trainingSessionProvider.exerciseProvider.plannedToActualExercises[exercise] == null) {
      if(isOnlinee) {
        String addId = await trainingSessionProvider.exerciseProvider.addBusinessClass(
          actualExercise, 
          scaffoldMessenger,
          notify: false
        );
        trainingSessionProvider.selectedActualSession!.trainingSessionExcercisesIds.add(addId);
        actualExercise.trainingExerciseID = addId;
        await trainingSessionProvider.updateBusinessClass(
          trainingSessionProvider.selectedActualSession!, 
          scaffoldMessenger,
          notify: false
        );
      }
    } else {
      if (isOnlinee) {
        await trainingSessionProvider.exerciseProvider.updateBusinessClass(actualExercise, scaffoldMessenger);
      } else {
        trainingSessionProvider.tempExercises.add(actualExercise);
      }
    }
  }

  Future<void> handleUnplannedExerciseUpdate(
    dynamic actualExercise, 
    ScaffoldMessengerState scaffoldMessenger
  ) async {
    if (isOnlinee) {
      await trainingSessionProvider.exerciseProvider.updateBusinessClass(actualExercise, scaffoldMessenger);
    } else {
      trainingSessionProvider.tempExercises.add(actualExercise);
    }
  }

  Future<void> handleExerciseDelete(
    dynamic exercise,
    dynamic actualExercise,
    ScaffoldMessengerState scaffoldMessenger
  ) async {
    if (trainingSessionProvider.exerciseProvider.plannedToActualExercises[exercise] != null ||
        trainingSessionProvider.exerciseProvider.unplannedExercisesForSession.contains(exercise)) {
      
      // Remove from all relevant lists
      trainingSessionProvider.selectedActualSession!.trainingSessionExcercisesIds
          .remove(actualExercise.trainingExerciseID);
      trainingSessionProvider.selectedActualSession!.trainingSessionExercises
          .remove(actualExercise);
      trainingSessionProvider.exerciseProvider.plannedToActualExercises.remove(exercise);
      trainingSessionProvider.getSelectedBusinessClass?.trainingSessionExercises.remove(exercise);
      trainingSessionProvider.exerciseProvider.unplannedExercisesForSession.remove(exercise);

      if (isOnlinee) {
        await trainingSessionProvider.exerciseProvider.deleteBusinessClass(
          actualExercise, 
          scaffoldMessenger,
          notify: false
        );
        await trainingSessionProvider.updateBusinessClass(
          trainingSessionProvider.selectedActualSession!, 
          scaffoldMessenger,
          notify: false
        );
      } else {
        trainingSessionProvider.tempExercisesToDelete.add(actualExercise);
      }
    }
  }
}