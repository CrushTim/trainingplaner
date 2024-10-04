import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainingplaner/backend/dataClasses/training_exercise_data.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_report_interface.dart';

class TrainingExerciseDataReport
    implements TrainingsplanerDataReportInterface<TrainingExerciseData> {
  @override
  Stream<List<TrainingExerciseData>> getAll() {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('trainingExercises');
    Stream<QuerySnapshot> stream = collectionReference.snapshots();
    return stream.map((querySnapshot) => querySnapshot.docs
        .map((doc) => TrainingExerciseData.fromSnapshot(doc))
        .toList());
  }
}
