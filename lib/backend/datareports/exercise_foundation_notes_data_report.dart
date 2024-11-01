
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainingplaner/backend/dataClasses/exercise_foundation_notes_data.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_report_interface.dart';

class ExerciseFoundationNotesDataReport implements TrainingsplanerDataReportInterface<ExerciseFoundationNotesData> {
  @override
  Stream<List<ExerciseFoundationNotesData>> getAll() {
    CollectionReference collection = FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).collection("exerciseFoundationNotes");
    return collection.snapshots().map((snapshot) => snapshot.docs.map((doc) => ExerciseFoundationNotesData.fromSnapshot(doc)).toList());
  }
}
