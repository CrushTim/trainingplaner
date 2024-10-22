import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class TrainingCycleData implements TrainingsplanerDataInterface {
  CollectionReference collection = FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).collection('trainingCycles');
  String trainingCycleID;
  String cycleName;
  String description;
  List<String> emphasis;
  DateTime beginDate;
  DateTime endDate;
  String? parent;

  TrainingCycleData({
    required this.trainingCycleID,
    required this.cycleName,
    required this.description,
    required this.emphasis,
    required this.beginDate,
    required this.endDate,
    this.parent,
  });

  factory TrainingCycleData.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return TrainingCycleData(
      trainingCycleID: snapshot.id,
      cycleName: snapshot['cycleName'],
      description: snapshot['description'],
      emphasis: List<String>.from(snapshot['emphasis']),
      beginDate: DateTime.parse(snapshot['beginDate']),
      endDate: DateTime.parse(snapshot['endDate']),
      parent: snapshot['parent'],
    );
  }
  factory TrainingCycleData.fromJson(Map<String, dynamic> json) {
    return TrainingCycleData(
      trainingCycleID: json['trainingCycleID'],
      cycleName: json['cycleName'],
      description: json['description'],
      emphasis: List<String>.from(json['emphasis']),
      beginDate: DateTime.parse(json['beginDate']),
      endDate: DateTime.parse(json['endDate']),
      parent: json['parent'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'trainingCycleID': trainingCycleID,
      'cycleName': cycleName,
      'description': description,
      'emphasis': emphasis,
      'beginDate': beginDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'parent': parent,
    };
  }

  @override
  Future<String> add() async {
    DocumentReference docRef = await collection.add(toJson());
    return docRef.id;
  }

  @override
  Future<void> delete() async {
    await collection.doc(trainingCycleID).delete();
  }

  @override
  Future<void> update() async {
    await collection.doc(trainingCycleID).update(toJson());
  }
}
