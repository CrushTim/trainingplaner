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
  String foundationId;
  double oneRepMax;
  DateTime date;

  UserSpecificExerciseData({
    required this.exerciseLinkID,
    required this.foundationId,
    required this.oneRepMax,
    required this.date,
  });

  factory UserSpecificExerciseData.fromSnapshot(
      QueryDocumentSnapshot snapshot) {
    return UserSpecificExerciseData(
      exerciseLinkID: snapshot.id,
      foundationId: snapshot['foundationId'],
      oneRepMax: snapshot['oneRepMax'],
      date: snapshot['date'].toDate(),
    );
  }

  factory UserSpecificExerciseData.fromJson(Map<String, dynamic> json) {
    return UserSpecificExerciseData(
      exerciseLinkID: json['exerciseLinkID'],
      foundationId: json['foundationId'],
      oneRepMax: json['oneRepMax'],
      date: json['date'].toDate(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'foundationId': foundationId,
      'oneRepMax': oneRepMax,
      'date': date,
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
