import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';

class ExerciseFoundationBusReport
    extends TrainingsplanerBusReportInterface<ExerciseFoundationBus> {
  @override
  Stream<List<ExerciseFoundationBus>> getAll() {
    // TODO: Implement the actual data fetching logic
    // This is a placeholder implementation
    return Stream.fromIterable([
      [
        ExerciseFoundationBus(
          exerciseFoundationId: "1",
          exerciseFoundationName: "Sample Exercise",
          exerciseFoundationDescription: "A sample exercise foundation",
          exerciseFoundationPicturePath: "path/to/picture.jpg",
          exerciseFoundationCategories: ["Strength", "Cardio"],
          exerciseFoundationMuscleGroups: ["Chest", "Triceps"],
          exerciseFoundationAmountOfPeople: 1,
        )
      ]
    ]);
  }
}
