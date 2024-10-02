import 'package:trainingplaner/backend/trainingsplaner_data_interface.dart';

class UserSpecificExerciseData implements TrainingsplanerDataInterface {
  String exerciseLinkID;
  String userID;
  String foundationId;
  String notes;
  double oneRepMax;

  UserSpecificExerciseData({
    required this.exerciseLinkID,
    required this.userID,
    required this.foundationId,
    required this.notes,
    required this.oneRepMax,
  });

  factory UserSpecificExerciseData.fromJson(Map<String, dynamic> json) {
    return UserSpecificExerciseData(
      exerciseLinkID: json['exerciseLinkID'],
      userID: json['userID'],
      foundationId: json['foundationId'],
      notes: json['notes'],
      oneRepMax: json['oneRepMax'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'exerciseLinkID': exerciseLinkID,
      'userID': userID,
      'foundationId': foundationId,
      'notes': notes,
      'oneRepMax': oneRepMax,
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
