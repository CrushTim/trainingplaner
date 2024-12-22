import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/reports/training_session_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
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
      trainingSessionExcercisesIds: List.from(plannedSession.trainingSessionExcercisesIds),
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
        ScaffoldMessenger.of(context), notify: false,
      );
    } else {
      await addForAddBusinessClass(
        ScaffoldMessenger.of(context), notify: false,
      );
    }
    
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> addTemporaryExercise(TrainingExerciseBus exercise, {bool notify = true}) async {
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
  }

  
} 