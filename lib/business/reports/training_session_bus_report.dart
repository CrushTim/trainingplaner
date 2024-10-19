import 'package:trainingplaner/backend/datareports/training_session_data_report.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class TrainingSessionBusReport extends TrainingsplanerBusReportInterface {
  TrainingSessionDataReport trainingSessionDataReport =
      TrainingSessionDataReport();
  @override
  Stream<List<TrainingSessionBus>> getAll() {
    return trainingSessionDataReport.getAll().map((list) => list.map((e) {
          return TrainingSessionBus.fromData(e);
        }).toList());
  }
}
