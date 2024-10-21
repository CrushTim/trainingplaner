import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class UserSpecificExerciseData implements TrainingsplanerDataInterface {

  CollectionReference collection = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth
      .instance.currentUser!.uid)
      .collection("userSpecificExercises");
  String exerciseLinkID;
  String userID;
  String foundationId;
  String notes;
  double oneRepMax;

  UserSpecificExerciseData({
    required this.exerciseLinkID,
    required this.userID,
    required this.foundationId,
    required this.notes,
    required this.oneRepMax,
  });

  factory UserSpecificExerciseData.fromSnapshot(
      QueryDocumentSnapshot snapshot) {
    return UserSpecificExerciseData(
      exerciseLinkID: snapshot.id,
      userID: snapshot['userID'],
      foundationId: snapshot['foundationId'],
      notes: snapshot['notes'],
      oneRepMax: snapshot['oneRepMax'],
    );
  }

  factory UserSpecificExerciseData.fromJson(Map<String, dynamic> json) {
    return UserSpecificExerciseData(
      exerciseLinkID: json['exerciseLinkID'],
      userID: json['userID'],
      foundationId: json['foundationId'],
      notes: json['notes'],
      oneRepMax: json['oneRepMax'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'exerciseLinkID': exerciseLinkID,
      'userID': userID,
      'foundationId': foundationId,
      'notes': notes,
      'oneRepMax': oneRepMax,
    };
  }

  @override
  Future<String> add() async {
    DocumentReference docRef = await collection.add(toJson());
    return docRef.id;
  }

  @override
  Future<void> update() async {
    await collection.doc(exerciseLinkID).update(toJson());
  }

  @override
  Future<void> delete() async {
    await collection.doc(exerciseLinkID).delete();
  }
}
