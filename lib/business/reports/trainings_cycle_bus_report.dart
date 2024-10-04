import 'package:trainingplaner/backend/datareports/training_cycle_data_report.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';

import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class TrainingCycleBusReport
    extends TrainingsplanerBusReportInterface<TrainingCycleBus> {
  TrainingCycleDataReport trainingCycleDataReport = TrainingCycleDataReport();
  @override
  Stream<List<TrainingCycleBus>> getAll() {
    return trainingCycleDataReport
        .getAll()
        .map((list) => list.map((e) => TrainingCycleBus.fromData(e)).toList());
  }
}
