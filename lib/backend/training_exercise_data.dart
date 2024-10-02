import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class TrainingExerciseData implements TrainingsplanerDataInterface {
  String trainingExerciseID;
  String exerciseName;
  String exerciseDescription;
  String exerciseFoundationID;
  List<double> exerciseWeights;
  List<int> exerciseReps;
  int targetPercentageOf1RM;
  bool isPlanned;
  DateTime date;
  String? plannedExerciseId;

  TrainingExerciseData({
    required this.trainingExerciseID,
    required this.exerciseName,
    required this.exerciseDescription,
    required this.exerciseFoundationID,
    required this.exerciseWeights,
    required this.exerciseReps,
    required this.targetPercentageOf1RM,
    required this.isPlanned,
    required this.date,
    this.plannedExerciseId,
  });

  factory TrainingExerciseData.fromJson(Map<String, dynamic> json) {
    return TrainingExerciseData(
      trainingExerciseID: json['trainingExerciseID'],
      exerciseName: json['exerciseName'],
      exerciseDescription: json['exerciseDescription'],
      exerciseFoundationID: json['exerciseFoundationID'],
      exerciseWeights: List<double>.from(json['exerciseWeights']),
      exerciseReps: List<int>.from(json['exerciseReps']),
      targetPercentageOf1RM: json['targetPercentageOf1RM'],
      isPlanned: json['isPlanned'],
      date: DateTime.parse(json['date']),
      plannedExerciseId: json['plannedExerciseId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'trainingExerciseID': trainingExerciseID,
      'exerciseName': exerciseName,
      'exerciseDescription': exerciseDescription,
      'exerciseFoundationID': exerciseFoundationID,
      'exerciseWeights': exerciseWeights,
      'exerciseReps': exerciseReps,
      'targetPercentageOf1RM': targetPercentageOf1RM,
      'isPlanned': isPlanned,
      'date': date.toIso8601String(),
      'plannedExerciseId': plannedExerciseId,
    };
  }

  @override
  Future<void> add() {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> update() {
    // TODO: implement update
    throw UnimplementedError();
  }
}
