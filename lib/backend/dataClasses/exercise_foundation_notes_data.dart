import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class ExerciseFoundationNotesData implements TrainingsplanerDataInterface {
  String exerciseFoundationNotesId;
  List<String> exerciseFoundationNotes;
  String exerciseFoundationId;

  CollectionReference collection = FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).collection("exerciseFoundationNotes");

  ExerciseFoundationNotesData({required this.exerciseFoundationNotesId, required this.exerciseFoundationNotes, required this.exerciseFoundationId});
  factory ExerciseFoundationNotesData.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return ExerciseFoundationNotesData(
      exerciseFoundationNotesId: snapshot.id,
      exerciseFoundationNotes: List<String>.from(snapshot['notes']),
      exerciseFoundationId: snapshot['exerciseFoundationId']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {"notes": exerciseFoundationNotes, "exerciseFoundationId": exerciseFoundationId};
  }

  @override
  Future<String> add() async {
    DocumentReference docRef = await collection.add(toJson());
    return docRef.id;
  }

  @override
  Future<void> update() async {
    await collection.doc(exerciseFoundationNotesId).update(toJson());
  }

  @override
  Future<void> delete() async {
    await collection.doc(exerciseFoundationNotesId).delete();
  }
}
