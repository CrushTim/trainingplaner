import 'package:trainingplaner/backend/datareports/exercise_foundation_data_report.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class ExerciseFoundationBusReport
    extends TrainingsplanerBusReportInterface<ExerciseFoundationBus> {
  ExerciseFoundationDataReport exerciseFoundationDataReport =
      ExerciseFoundationDataReport();

  @override
  Stream<List<ExerciseFoundationBus>> getAll() {
    return exerciseFoundationDataReport.getAll().map(
        (list) => list.map((e) => ExerciseFoundationBus.fromData(e)).toList());
  }

  Stream<List<ExerciseFoundationBus>> getPaginated(int lastIndex) {
    return exerciseFoundationDataReport.getPaginated(lastIndex).map(
        (list) => list.map((e) => ExerciseFoundationBus.fromData(e)).toList());
  }
}
