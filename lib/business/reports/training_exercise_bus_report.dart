import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class TrainingExerciseBusReport
    extends TrainingsplanerBusReportInterface<TrainingExerciseBus> {
  @override
  Stream<List<TrainingExerciseBus>> getAll() {
    // TODO: Implement the actual data fetching logic
    // This is a placeholder implementation
    return Stream.fromIterable([
      [
        TrainingExerciseBus(
          trainingExerciseID: "1",
          exerciseName: "Sample Exercise",
          exerciseDescription: "A sample training exercise",
          date: DateTime.now(),
          exerciseFoundationID: "foundation1",
          exerciseReps: [10, 10, 8],
          exerciseWeights: [50.0, 50.0, 45.0],
          isPlanned: true,
          targetPercentageOf1RM: 75,
        )
      ]
    ]);
  }
}
