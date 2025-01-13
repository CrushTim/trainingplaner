import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/reports/training_session_bus_report.dart';
import 'package:trainingplaner/frontend/ParentClasses/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_exercise_provider.dart';
import 'package:trainingplaner/main.dart';
import 'package:trainingplaner/services/connectivity_service.dart';

class PlanningProvider extends TrainingsplanerProvider<TrainingSessionBus, TrainingSessionBusReport> {
  final TextEditingController sessionNameController = TextEditingController();
  final TextEditingController sessionDescriptionController = TextEditingController();
  final TextEditingController sessionEmphasisController = TextEditingController();
  final TextEditingController sessionLengthController = TextEditingController();
  DateTime selectedSessionDate = DateTime.now();
  
  List<TrainingSessionBus> copiedSessions = [];
  int? copiedWeek;

  final ConnectivityService _connectivityService = ConnectivityService();
  List<TrainingExerciseBus> tempExercises = [];
  late TrainingExerciseProvider exerciseProvider;

  List<TrainingExerciseBus> exercisesToDeleteIfSessionAddIsCancelled = [];

  PlanningProvider({required this.exerciseProvider}) : super(
    businessClassForAdd: TrainingSessionBus(
      trainingSessionId: "",
      trainingSessionName: "",
      trainingSessionDescription: "",
      trainingSessionStartDate: DateTime.now(),
      trainingSessionLength: 60,
      trainingSessionExcercisesIds: [],
      trainingSessionEmphasis: [""],
      isPlanned: true,
      trainingCycleId: "",
    ),
    reportTaskVar: TrainingSessionBusReport(),
  );

  void initControllersForPlanningView() {
    final target = getSelectedBusinessClass;
    if (target != null) {
      sessionNameController.text = target.trainingSessionName;
      sessionDescriptionController.text = target.trainingSessionDescription;
      sessionEmphasisController.text = target.trainingSessionEmphasis.join(', ');
      sessionLengthController.text = target.trainingSessionLength.toString();
      selectedSessionDate = target.trainingSessionStartDate;
    } else {
      sessionNameController.clear();
      sessionDescriptionController.clear();
      sessionEmphasisController.clear();
      sessionLengthController.text = "60";
      businessClassForAdd.trainingSessionStartDate = selectedSessionDate;
    }
  }

   void resetSessionControllers() {
    sessionNameController.clear();
    sessionDescriptionController.clear();
    sessionEmphasisController.clear();
    sessionLengthController.text = "60";
  }


  void handleSessionFieldChangeForPlanned(String field, String value) {
    final target = getSelectedBusinessClass ?? businessClassForAdd;
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
    selectedSessionDate = date;
    final target = getSelectedBusinessClass ?? businessClassForAdd;
    target.trainingSessionStartDate = date;
    notifyListeners();
  }

  void storeWeekSessions(List<TrainingSessionBus> sessions, int week) {
    copiedSessions = sessions;
    copiedWeek = week;
  }

  Future<void> insertWeekSessions(
    int targetWeek,
    ScaffoldMessengerState scaffoldMessenger,
  ) async {
  
    if (copiedSessions.isEmpty || copiedWeek == null) return;

    final weekDifference = targetWeek - copiedWeek!;
    final daysToAdd = weekDifference * 7;

    try {
      for (var session in copiedSessions) {
        final newDate = session.trainingSessionStartDate.add(Duration(days: daysToAdd));
        await copySessionToDate(
          session,
          newDate,
          scaffoldMessenger,
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error copying week: ${e.toString()}')),
      );
    }
  }

  Future<void> copySessionToDate(
    TrainingSessionBus plannedSession,
    DateTime newDate,
    ScaffoldMessengerState scaffoldMessengerState,
  ) async {
    print(plannedSession.trainingSessionExercises);
    List<String> newExerciseIds = await exerciseProvider.createExerciseCopies(
        plannedSession.trainingSessionExercises,
        scaffoldMessengerState
      );


    final newSession = TrainingSessionBus(
      trainingSessionId: "",
      trainingSessionName: plannedSession.trainingSessionName,
      trainingSessionDescription: plannedSession.trainingSessionDescription,
      trainingSessionStartDate: DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        plannedSession.trainingSessionStartDate.hour,
        plannedSession.trainingSessionStartDate.minute,
      ),
      trainingSessionLength: plannedSession.trainingSessionLength,
      trainingSessionExcercisesIds: newExerciseIds,
      trainingSessionEmphasis: List.from(plannedSession.trainingSessionEmphasis),
      isPlanned: true,
      trainingCycleId: plannedSession.trainingCycleId,
    );

    try {
      await addBusinessClass(newSession, scaffoldMessengerState, notify: false);
    } catch (e) {
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text('Error copying session: ${e.toString()}')),
      );
    }
  }

  Future<void> saveSession(BuildContext context) async {
    if (getSelectedBusinessClass != null) {
      await updateSelectedBusinessClass(
        ScaffoldMessenger.of(context), 
        notify: false,
      );
    } else {
      await addForAddBusinessClass(
        ScaffoldMessenger.of(context), 
        notify: false,
      );
      resetBusinessClassForAdd();
      businessClassForAdd.trainingSessionExercises.clear();
      businessClassForAdd.trainingSessionExcercisesIds.clear();
    }
    
    // Clear the list of exercises to delete since we successfully saved
    exercisesToDeleteIfSessionAddIsCancelled.clear();
    
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<TrainingExerciseBus?> addTemporaryExercise(TrainingExerciseBus exercise, {bool notify = true}) async {
    TrainingExerciseBus exerciseCopy = TrainingExerciseBus(
        trainingExerciseID: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        exerciseName: exercise.exerciseName,
        exerciseDescription: exercise.exerciseDescription,
        exerciseFoundationID: exercise.exerciseFoundationID,
        exerciseReps: List.from(exercise.exerciseReps),
        exerciseWeights: List.from(exercise.exerciseWeights),
        date: exercise.date,
        isPlanned: true,
        targetPercentageOf1RM: exercise.targetPercentageOf1RM,
      );
    if (_connectivityService.isConnected) {
      // Online - add directly to database
      final permanentId = await exerciseProvider.addBusinessClass(
        exercise,
        ScaffoldMessenger.of(navigatorKey.currentContext!),
      );
      exerciseCopy.trainingExerciseID = permanentId;
      

      if(getSelectedBusinessClass != null) {
       getSelectedBusinessClass?.trainingSessionExcercisesIds.add(permanentId);
      getSelectedBusinessClass?.trainingSessionExercises.add(exerciseCopy);

      updateBusinessClass(getSelectedBusinessClass!, ScaffoldMessenger.of(navigatorKey.currentContext!), notify: notify);
      } else {
        businessClassForAdd.trainingSessionExercises.add(exerciseCopy);
        businessClassForAdd.trainingSessionExcercisesIds.add(exerciseCopy.trainingExerciseID);
      }
    
    } else {
      // Offline - add to temporary storage
      if(getSelectedBusinessClass != null) {
        getSelectedBusinessClass?.trainingSessionExcercisesIds.add(exerciseCopy.trainingExerciseID);
        getSelectedBusinessClass?.trainingSessionExercises.add(exerciseCopy);
      } else {
        businessClassForAdd.trainingSessionExcercisesIds.add(exerciseCopy.trainingExerciseID);
        businessClassForAdd.trainingSessionExercises.add(exerciseCopy);
      }
      tempExercises.add(exerciseCopy);
    }
    if(notify) {
      notifyListeners();
    }

    return exerciseCopy;
  }

  Future<void> adjustWeekExercisesParameters(
    List<TrainingSessionBus> sessions,
    int percentageChange,
    int setChange,
    int repChange,
    ScaffoldMessengerState scaffoldMessenger,
  ) async {
    List<TrainingExerciseBus> exercisesToUpdate = [];
    
    // Collect all exercises from all sessions
    for (var session in sessions) {
      exercisesToUpdate.addAll(session.trainingSessionExercises);
    }

    // Apply changes to each exercise
    for (var exercise in exercisesToUpdate) {
      // Apply percentage change if provided
      if (percentageChange != 0) {
        int newPercentage = exercise.targetPercentageOf1RM + percentageChange;
        exercise.targetPercentageOf1RM = newPercentage.clamp(0, 100);
      }

      // Apply set changes if provided
      if (setChange != 0) {
        if (setChange > 0) {
          // Add sets
          for (int i = 0; i < setChange; i++) {
            // Default to 1 rep if no existing sets
            int defaultReps = exercise.exerciseReps.isEmpty ? 1 : exercise.exerciseReps.last;
            exercise.exerciseReps.add(defaultReps);
            
            // Default to 0 weight or copy last weight
            double defaultWeight = exercise.exerciseWeights.isEmpty ? 0 : exercise.exerciseWeights.last;
            exercise.exerciseWeights.add(defaultWeight);
          }
        } else {
          // Remove sets (ensure at least one set remains)
          int setsToRemove = setChange.abs();
          int minSets = 1;
          while (setsToRemove > 0 && exercise.exerciseReps.length > minSets) {
            exercise.exerciseReps.removeLast();
            exercise.exerciseWeights.removeLast();
            setsToRemove--;
          }
        }
      }

      // Apply rep changes if provided
      if (repChange != 0) {
        for (int i = 0; i < exercise.exerciseReps.length; i++) {
          int newReps = exercise.exerciseReps[i] + repChange;
          exercise.exerciseReps[i] = newReps > 0 ? newReps : 1; // Ensure reps don't go below 1
        }
      }
    }

    try {
      // Update all modified exercises
      await exerciseProvider.updateExercises(
        exercisesToUpdate,
        scaffoldMessenger,
        notify: false,
      );

      // Update all affected sessions
      for (var session in sessions) {
        await updateBusinessClass(session, scaffoldMessenger, notify: false);
      }

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Training parameters updated successfully')),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error updating training parameters: ${e.toString()}')),
      );
    }
  }

 Future<void> deloadWeekSessions(List<TrainingSessionBus> sessions, int week, BuildContext context)async {
  for (var session in sessions) {
    for (var exercise in session.trainingSessionExercises) {
      for (var rep in exercise.exerciseReps) {
        exercise.exerciseReps[exercise.exerciseReps.indexOf(rep)] = (rep * 0.5).round();
      }
      await exerciseProvider.updateBusinessClass(exercise, ScaffoldMessenger.of(context), notify: false);
    }
  }
 }
} 