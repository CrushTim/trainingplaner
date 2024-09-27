import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/reports/training_session_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';

class TrainingSessionProvider extends TrainingsplanerProvider<
    TrainingSessionBus, TrainingSessionBusReport> {
  TrainingSessionProvider()
      : super(
            businessClassForAdd: TrainingSessionBus(
                trainingSessionId: "",
                isPlanned: true,
                trainingSessionName: "",
                trainingSessionDescription: "",
                trainingSessionEmphasis: "",
                trainingSessionExcercises: [],
                trainingSessionLength: 1,
                trainingSessionStartDate: DateTime.now(),
                trainingCycleId: ""));
}
