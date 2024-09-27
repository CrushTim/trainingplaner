import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class TrainingSessionBusReport extends TrainingsplanerBusReportInterface {
  @override
  Stream<List> getAll() {
    return Stream.fromIterable([
      [
        {
          'trainingSessionId': '1',
          'trainingSessionName': 'Strength Training',
          'trainingSessionDescription': 'Focus on building core strength',
          'trainingSessionEmphasis': 'Core',
          'trainingSessionLength': 60,
          'trainingSessionStartDate': DateTime.now(),
          'trainingCycleId': 'TC001',
        },
        {
          'trainingSessionId': '2',
          'trainingSessionName': 'Cardio Session',
          'trainingSessionDescription': 'High-intensity interval training',
          'trainingSessionEmphasis': 'Endurance',
          'trainingSessionLength': 45,
          'trainingSessionStartDate': DateTime.now().add(Duration(days: 2)),
          'trainingCycleId': 'TC001',
        },
        {
          'trainingSessionId': '3',
          'trainingSessionName': 'Flexibility Workshop',
          'trainingSessionDescription': 'Stretching and mobility exercises',
          'trainingSessionEmphasis': 'Flexibility',
          'trainingSessionLength': 30,
          'trainingSessionStartDate': DateTime.now().add(Duration(days: 4)),
          'trainingCycleId': 'TC001',
        },
      ]
    ]);
  }
}
