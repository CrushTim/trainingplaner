import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class ExerciseFoundationData implements TrainingsplanerDataInterface {
  CollectionReference collection = FirebaseFirestore.instance
      .collection("exerciseFoundations");
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': exerciseFoundationName,
      'description': exerciseFoundationDescription,
      'picturePath': exerciseFoundationPicturePath,
      'categories': exerciseFoundationCategories,
      'muscleGroups': exerciseFoundationMuscleGroups,
      'amountOfPeople': exerciseFoundationAmountOfPeople,
    };
  }

  @override
  Future<String> add() async {
    DocumentReference docRef = await collection.add(toJson());
    return docRef.id;
  }

  @override
  Future<void> delete() async {
    await collection.doc(exerciseFoundationId).delete();
  }

  @override
  Future<void> update() async {
    await collection.doc(exerciseFoundationId).update(toJson());
  }
}
