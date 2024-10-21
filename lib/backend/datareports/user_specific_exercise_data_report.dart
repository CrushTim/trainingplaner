
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainingplaner/backend/dataClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_report_interface.dart';

class UserSpecificExerciseDataReport
    implements TrainingsplanerDataReportInterface<UserSpecificExerciseData> {
  @override
  Stream<List<UserSpecificExerciseData>> getAll() {
    return FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).collection("exerciseLinks").snapshots().map((snapshot) => snapshot.docs.map((doc) => UserSpecificExerciseData.fromSnapshot(doc)).toList());
  }
}

