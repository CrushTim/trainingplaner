import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainingplaner/backend/dataClasses/exercise_foundation_data.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_report_interface.dart';

class ExerciseFoundationDataReport
    implements TrainingsplanerDataReportInterface<ExerciseFoundationData> {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('exerciseFoundations');

      @override
        Stream<List<ExerciseFoundationData>> getAll() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('exerciseFoundations');
    Stream<QuerySnapshot> stream = collectionReference.snapshots();
    return stream.map((querySnapshot) => querySnapshot.docs
        .map((doc) => ExerciseFoundationData.fromSnapshot(doc))
        .toList());
  }

  ExerciseFoundationData fromSnapshot(QueryDocumentSnapshot doc) {
    return ExerciseFoundationData.fromSnapshot(doc);
  }

  Stream<List<ExerciseFoundationData>> getInitialBatch() {
    return collection
      .orderBy('name')
      .limit(20)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => ExerciseFoundationData.fromSnapshot(doc))
          .toList());
  }

  Stream<List<ExerciseFoundationData>> getRemainingData(String lastExerciseFoundationName) {
    return collection
      .orderBy('name')
      .limit(20)
      .startAfter([lastExerciseFoundationName])
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => ExerciseFoundationData.fromSnapshot(doc))
          .toList());
  }
}
