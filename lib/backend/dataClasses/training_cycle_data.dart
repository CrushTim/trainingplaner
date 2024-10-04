import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class TrainingCycleData implements TrainingsplanerDataInterface {
  String trainingCycleID;
  String cycleName;
  String description;
  String emphasis;
  String userID;
  DateTime beginDate;
  DateTime endDate;
  String? parent;

  TrainingCycleData({
    required this.trainingCycleID,
    required this.cycleName,
    required this.description,
    required this.emphasis,
    required this.userID,
    required this.beginDate,
    required this.endDate,
    this.parent,
  });

  factory TrainingCycleData.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return TrainingCycleData(
      trainingCycleID: snapshot.id,
      cycleName: snapshot['name'],
      description: snapshot['description'],
      emphasis: snapshot['emphasis'],
      userID: snapshot['userID'],
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
      emphasis: json['emphasis'],
      userID: json['userID'],
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
      'userID': userID,
      'beginDate': beginDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'parent': parent,
    };
  }

  @override
  Future<void> add() {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> update() {
    // TODO: implement update
    throw UnimplementedError();
  }
}
