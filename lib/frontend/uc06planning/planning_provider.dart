import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';

class PlanningProvider with ChangeNotifier {
  List<TrainingSessionBus> copiedSessions = [];

  void storeWeekSessions(List<TrainingSessionBus> sessions) {
    copiedSessions = sessions;
    notifyListeners();
  }

  void clearCopiedSessions() {
    copiedSessions = [];
    notifyListeners();
  }
} 