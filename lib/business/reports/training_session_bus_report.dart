import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class TrainingSessionBusReport extends TrainingsplanerBusReportInterface {
  @override
  Stream<List<TrainingSessionBus>> getAll() {
    return Stream.fromIterable([
      [
        TrainingSessionBus(
          trainingSessionId: '1',
          trainingSessionName: 'Strength Training',
          trainingSessionDescription: 'Focus on building core strength',
          trainingSessionEmphasis: 'Strength',
          trainingSessionLength: 60,
          trainingSessionStartDate: DateTime.now(),
          trainingCycleId: 'TC001',
          isPlanned: true,
          trainingSessionExcercisesIds: [],
        ),
        TrainingSessionBus(
          trainingSessionId: '2',
          trainingSessionName: 'Cardio Session',
          trainingSessionDescription: 'High-intensity interval training',
          trainingSessionEmphasis: 'Endurance',
          trainingSessionLength: 45,
          trainingSessionStartDate: DateTime.now().add(Duration(days: 2)),
          trainingCycleId: 'TC001',
          isPlanned: true,
          trainingSessionExcercisesIds: [],
        ),
        TrainingSessionBus(
          trainingSessionId: '3',
          trainingSessionName: 'Flexibility Workshop',
          trainingSessionDescription: 'Stretching and mobility exercises',
          trainingSessionEmphasis: 'Flexibility',
          trainingSessionLength: 30,
          trainingSessionStartDate: DateTime.now().add(Duration(days: 4)),
          trainingCycleId: 'TC001',
          isPlanned: true,
          trainingSessionExcercisesIds: [],
        ),
      ]
    ]);
  }

  ///gets all the training sessions for a user
  Stream<List<TrainingSessionBus>> getAllForUser() {
    return Stream.fromIterable([
      [
        TrainingSessionBus(
          trainingSessionId: '1',
          trainingSessionName: 'Strength Training',
          trainingSessionDescription: 'Focus on building core strength',
          trainingSessionEmphasis: 'Strength',
          trainingSessionLength: 60,
          trainingSessionStartDate: DateTime.now(),
          trainingCycleId: 'TC001',
          isPlanned: true,
          trainingSessionExcercisesIds: [],
        ),
      ]
    ]);
  }
}
