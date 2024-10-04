import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainingplaner/backend/dataClasses/exercise_foundation_data.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_report_interface.dart';

class ExerciseFoundationDataReport
    implements TrainingsplanerDataReportInterface<ExerciseFoundationData> {
  @override
  Stream<List<ExerciseFoundationData>> getAll() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('exerciseFoundations');
    Stream<QuerySnapshot> stream = collectionReference.snapshots();
    return stream.map((querySnapshot) => querySnapshot.docs
        .map((doc) => ExerciseFoundationData.fromSnapshot(doc))
        .toList());
  }
}
