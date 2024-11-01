import 'package:trainingplaner/backend/datareports/exercise_foundation_notes_data_report.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_notes.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class ExerciseFoundationNotesBusReport implements TrainingsplanerBusReportInterface<ExerciseFoundationNotesBus> {
  @override
  Stream<List<ExerciseFoundationNotesBus>> getAll() {
    return ExerciseFoundationNotesDataReport().getAll().map((data) => data.map((d) => ExerciseFoundationNotesBus.fromData(d)).toList());
  }
}
