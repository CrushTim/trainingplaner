import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class TrainingExerciseData implements TrainingsplanerDataInterface {
  CollectionReference collection = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("trainingExercises");

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

  factory TrainingExerciseData.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return TrainingExerciseData(
      trainingExerciseID: snapshot.id,
      exerciseName: snapshot['name'],
      exerciseDescription: snapshot['description'],
      exerciseFoundationID: snapshot['ExerciseFoundationId'],
      exerciseWeights: List<double>.from(snapshot['weights']),
      exerciseReps: List<int>.from(snapshot['reps']),
      targetPercentageOf1RM: snapshot['targetPercentage'],
      isPlanned: snapshot['isPlanned'],
      date: snapshot['date'].toDate() ?? DateTime.now(),
      plannedExerciseId: snapshot['plannedExerciseId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': exerciseName,
      'description': exerciseDescription,
      'ExerciseFoundationId': exerciseFoundationID,
      'weights': exerciseWeights,
      'reps': exerciseReps,
      'targetPercentage': targetPercentageOf1RM,
      'isPlanned': isPlanned,
      'date': Timestamp.fromDate(date),
      'plannedExerciseId': plannedExerciseId,
    };
  }

  @override
  Future<void> add() async {
    await collection.add(toJson());
  }

  @override
  Future<void> delete() async {
    await collection.doc(trainingExerciseID).delete();
  }

  @override
  Future<void> update() async {
    await collection.doc(trainingExerciseID).update(toJson());
  }
}
