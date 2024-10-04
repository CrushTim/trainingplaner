import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class TrainingSessionData implements TrainingsplanerDataInterface {
  String trainingSessionId;
  String trainingSessionName;
  String trainingSessionDescription;
  DateTime trainingSessionStartDate;
  int trainingSessionLength;
  List<String> trainingSessionExcercisesIds;
  String trainingSessionEmphasis;
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
      trainingSessionStartDate:
          DateTime.parse(snapshot['trainingSessionStartDate']),
      trainingSessionLength: snapshot['trainingSessionLength'],
      trainingSessionExcercisesIds:
          List<String>.from(snapshot['trainingSessionExcercisesIds']),
      trainingSessionEmphasis: snapshot['trainingSessionEmphasis'],
      isPlanned: snapshot['isPlanned'],
      trainingCycleId: snapshot['trainingCycleId'],
    );
  }

  // /////////////////////////////////////////////
  // JSON
  // /////////////////////////////////////////////

  factory TrainingSessionData.fromJson(Map<String, dynamic> json) {
    return TrainingSessionData(
      trainingSessionId: json['trainingSessionId'],
      trainingSessionName: json['trainingSessionName'],
      trainingSessionDescription: json['trainingSessionDescription'],
      trainingSessionStartDate:
          DateTime.parse(json['trainingSessionStartDate']),
      trainingSessionLength: json['trainingSessionLength'],
      trainingSessionExcercisesIds:
          List<String>.from(json['trainingSessionExcercisesIds']),
      trainingSessionEmphasis: json['trainingSessionEmphasis'],
      isPlanned: json['isPlanned'],
      trainingCycleId: json['trainingCycleId'],
      plannedSessionId: json['plannedSessionId'],
      actualExercisesIds: List<String>.from(json['actualExercisesIds'] ?? []),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'trainingSessionId': trainingSessionId,
      'trainingSessionName': trainingSessionName,
      'trainingSessionDescription': trainingSessionDescription,
      'trainingSessionStartDate': trainingSessionStartDate.toIso8601String(),
      'trainingSessionLength': trainingSessionLength,
      'trainingSessionExcercisesIds': trainingSessionExcercisesIds,
      'trainingSessionEmphasis': trainingSessionEmphasis,
      'isPlanned': isPlanned,
      'trainingCycleId': trainingCycleId,
      'plannedSessionId': plannedSessionId,
      'actualExercisesIds': actualExercisesIds,
    };
  }

  // /////////////////////////////////////////////
  // CRUD
  // /////////////////////////////////////////////

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
