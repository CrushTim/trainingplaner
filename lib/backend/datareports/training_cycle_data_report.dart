import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_report_interface.dart';
import 'package:trainingplaner/backend/dataClasses/training_cycle_data.dart';

class TrainingCycleDataReport
    implements TrainingsplanerDataReportInterface<TrainingCycleData> {
  @override
  Stream<List<TrainingCycleData>> getAll() {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('trainingCycles');
    Stream<QuerySnapshot> stream = collectionReference.snapshots();
    return stream.map((querySnapshot) => querySnapshot.docs
        .map((doc) => TrainingCycleData.fromSnapshot(doc))
        .toList());
  }
}
