import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainingplaner/backend/dataClasses/training_session_data.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_report_interface.dart';

class TrainingSessionDataReport
    implements TrainingsplanerDataReportInterface<TrainingSessionData> {
  @override
  Stream<List<TrainingSessionData>> getAll() {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('trainingSessions');
    Stream<QuerySnapshot> stream = collectionReference.snapshots();
    return stream.map((querySnapshot) => querySnapshot.docs
        .map((doc) => TrainingSessionData.fromSnapshot(doc))
        .toList());
  }
}
