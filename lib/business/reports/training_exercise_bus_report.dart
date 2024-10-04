import 'package:trainingplaner/backend/datareports/training_exercise_data_report.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class TrainingExerciseBusReport
    extends TrainingsplanerBusReportInterface<TrainingExerciseBus> {
  TrainingExerciseDataReport trainingExerciseDataReport =
      TrainingExerciseDataReport();

  @override
  Stream<List<TrainingExerciseBus>> getAll() {
    return trainingExerciseDataReport.getAll().map(
        (list) => list.map((e) => TrainingExerciseBus.fromData(e)).toList());
  }
}
