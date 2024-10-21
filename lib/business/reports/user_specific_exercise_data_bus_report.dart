
import 'package:trainingplaner/backend/datareports/user_specific_exercise_data_report.dart';
import 'package:trainingplaner/business/businessClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class UserSpecificExerciseDataBusReport extends TrainingsplanerBusReportInterface{
  UserSpecificExerciseDataReport userSpecificExerciseDataReport =
      UserSpecificExerciseDataReport();

  @override
  Stream<List<UserSpecificExerciseBus>> getAll() {
    return userSpecificExerciseDataReport.getAll().map((list) => list.map((e) {
          return UserSpecificExerciseBus.fromData(e);
        }).toList());
  }
}

