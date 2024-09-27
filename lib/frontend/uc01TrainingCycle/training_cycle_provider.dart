import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/business/reports/trainings_cycle_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';

class TrainingCycleProvider
    extends TrainingsplanerProvider<TrainingCycleBus, TrainingCycleBusReport> {
  TrainingCycleProvider()
      : super(
            businessClassForAdd: TrainingCycleBus(
                trainingCycleID: "",
                cycleName: "",
                description: "",
                emphasis: "",
                userID: "",
                beginDate: DateTime.now(),
                endDate: DateTime.now()));
}
