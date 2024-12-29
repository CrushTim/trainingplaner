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

  final int pageSize = 10;  // Number of items per page

  Stream<List<ExerciseFoundationData>> getPaginated(int lastIndex) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('exerciseFoundations');
        
    return collectionReference
      .orderBy('name')  // Order by name or any other field
      .limit(pageSize)
      .startAfter([lastIndex])
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => ExerciseFoundationData.fromSnapshot(doc))
          .toList());
  }
}
