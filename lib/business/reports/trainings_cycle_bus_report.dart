import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class TrainingCycleBusReport
    extends TrainingsplanerBusReportInterface<TrainingCycleBus> {
  @override
  Stream<List<TrainingCycleBus>> getAll() {
    // TODO: Implement the actual data fetching logic
    // This is a placeholder implementation
    return Stream.fromIterable([
      [
        TrainingCycleBus(
          trainingCycleID: "1",
          cycleName: "Sample Cycle",
          description: "A sample training cycle",
          emphasis: "Strength",
          userID: "user1",
          beginDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
        )
      ]
    ]);
  }
}
