import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class PlanningProvider with ChangeNotifier {
  List<TrainingSessionBus> copiedSessions = [];
  int? copiedWeek;


  void storeWeekSessions(List<TrainingSessionBus> sessions, int week) {
    copiedSessions = sessions;
    copiedWeek = week;
    notifyListeners();
  }

  Future<void> insertWeekSessions(
    int targetWeek,
    TrainingSessionProvider sessionProvider,
    ScaffoldMessengerState scaffoldMessenger,
  ) async {
    if (copiedSessions.isEmpty || copiedWeek == null) return;

    final weekDifference = targetWeek - copiedWeek!;
    final daysToAdd = weekDifference * 7;

    try {
      for (var session in copiedSessions) {
        final newDate = session.trainingSessionStartDate.add(Duration(days: daysToAdd));
        await sessionProvider.copySessionToDate(
          session,
          newDate,
          scaffoldMessenger,
        );
      }
      clearCopiedSessions();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error inserting sessions: ${e.toString()}')),
      );
    }
  }

  void clearCopiedSessions() {
    copiedSessions = [];
    copiedWeek = null;
    notifyListeners();
  }
} 