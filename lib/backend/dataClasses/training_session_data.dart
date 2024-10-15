import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class TrainingSessionData implements TrainingsplanerDataInterface {
  CollectionReference collection = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("trainingSessions");
  String trainingSessionId;
  String trainingSessionName;
  String trainingSessionDescription;
  DateTime trainingSessionStartDate;
  int trainingSessionLength;
  List<String> trainingSessionExcercisesIds;
  List<String> trainingSessionEmphasis;
  bool isPlanned;
  String trainingCycleId;
  String? plannedSessionId;
  List<String> actualExercisesIds;

  TrainingSessionData({
    required this.trainingSessionId,
    required this.trainingSessionName,
    required this.trainingSessionDescription,
    required this.trainingSessionStartDate,
    required this.trainingSessionLength,
    required this.trainingSessionExcercisesIds,
    required this.trainingSessionEmphasis,
    required this.isPlanned,
    required this.trainingCycleId,
    this.plannedSessionId,
    this.actualExercisesIds = const [],
  });

  factory TrainingSessionData.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return TrainingSessionData(
      trainingSessionId: snapshot.id,
      trainingSessionName: snapshot['name'],
      trainingSessionDescription: snapshot['description'],
      trainingSessionStartDate: snapshot['date'].toDate() ?? DateTime.now(),
      trainingSessionLength: snapshot['sessionLength'],
      trainingSessionExcercisesIds: List<String>.from(snapshot['exerciseIds']),
      trainingSessionEmphasis: List<String>.from(snapshot['emphasis']),
      isPlanned: snapshot['isPlanned'],
      trainingCycleId: snapshot['cycleId'],
      plannedSessionId: snapshot['plannedSessionId'],
    );
  }

  // /////////////////////////////////////////////
  // JSON
  // /////////////////////////////////////////////

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': trainingSessionName,
      'description': trainingSessionDescription,
      'date': Timestamp.fromDate(trainingSessionStartDate),
      'sessionLength': trainingSessionLength,
      'exerciseIds': trainingSessionExcercisesIds,
      'emphasis': trainingSessionEmphasis,
      'isPlanned': isPlanned,
      'cycleId': trainingCycleId,
      'plannedSessionId': plannedSessionId,
    };
  }

  // /////////////////////////////////////////////
  // CRUD
  // /////////////////////////////////////////////

  @override
  Future<String> add() async {
    DocumentReference docRef = await collection.add(toJson());
    return docRef.id;
  }

  @override
  Future<void> delete() async {
    await collection.doc(trainingSessionId).delete();
  }

  @override
  Future<void> update() async {
    await collection.doc(trainingSessionId).update(toJson());
  }
}
