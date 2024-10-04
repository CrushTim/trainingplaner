import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class ExerciseFoundationData implements TrainingsplanerDataInterface {
  String exerciseFoundationId;
  String exerciseFoundationName;
  String exerciseFoundationDescription;
  String exerciseFoundationPicturePath;
  List<String> exerciseFoundationCategories;
  List<String> exerciseFoundationMuscleGroups;
  int exerciseFoundationAmountOfPeople;

  ExerciseFoundationData({
    required this.exerciseFoundationId,
    required this.exerciseFoundationName,
    required this.exerciseFoundationDescription,
    required this.exerciseFoundationPicturePath,
    required this.exerciseFoundationCategories,
    required this.exerciseFoundationMuscleGroups,
    required this.exerciseFoundationAmountOfPeople,
  });

  factory ExerciseFoundationData.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return ExerciseFoundationData(
      exerciseFoundationId: snapshot.id,
      exerciseFoundationName: snapshot['name'],
      exerciseFoundationDescription: snapshot['description'],
      exerciseFoundationPicturePath: snapshot['picturePath'],
      exerciseFoundationCategories: List<String>.from(snapshot['categories']),
      exerciseFoundationMuscleGroups:
          List<String>.from(snapshot['muscleGroups']),
      exerciseFoundationAmountOfPeople: snapshot['amountOfPeople'],
    );
  }
  factory ExerciseFoundationData.fromJson(Map<String, dynamic> json) {
    return ExerciseFoundationData(
      exerciseFoundationId: json['exerciseFoundationId'],
      exerciseFoundationName: json['exerciseFoundationName'],
      exerciseFoundationDescription: json['exerciseFoundationDescription'],
      exerciseFoundationPicturePath: json['exerciseFoundationPicturePath'],
      exerciseFoundationCategories:
          List<String>.from(json['exerciseFoundationCategories']),
      exerciseFoundationMuscleGroups:
          List<String>.from(json['exerciseFoundationMuscleGroups']),
      exerciseFoundationAmountOfPeople:
          json['exerciseFoundationAmountOfPeople'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'exerciseFoundationId': exerciseFoundationId,
      'exerciseFoundationName': exerciseFoundationName,
      'exerciseFoundationDescription': exerciseFoundationDescription,
      'exerciseFoundationPicturePath': exerciseFoundationPicturePath,
      'exerciseFoundationCategories': exerciseFoundationCategories,
      'exerciseFoundationMuscleGroups': exerciseFoundationMuscleGroups,
      'exerciseFoundationAmountOfPeople': exerciseFoundationAmountOfPeople,
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
