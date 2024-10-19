import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

class UserSpecificExerciseData
    implements TrainingsplanerBusInterface<UserSpecificExerciseData> {
  ///the id of the user specific excercise data link
  String exerciseLinkID;

  ///the id of the user
  String userID;

  ///the foundation id the user has specific data for
  String foundationId;

  ///Notes the user has written for this excercise
  String notes;

  ///the current one Rep Max
  double oneRepMax;

  UserSpecificExerciseData({
    required this.exerciseLinkID,
    required this.userID,
    required this.foundationId,
    required this.notes,
    required this.oneRepMax,
  });

  ///factory method to create a training cycle from a data base object
  //TODO: implement the factory method
  factory UserSpecificExerciseData.fromData() {
    throw UnimplementedError();
  }

  ///method to convert the training cycle to a data base object
  //TODO: implement the toData method
  @override
  toData() {
    throw UnimplementedError();
  }

  ///resets every field of the training cycle to the default value
  @override
  void reset() {
    exerciseLinkID = "";
    userID = "";
    foundationId = "";
    notes = "";
    oneRepMax = 0;
  }

  ///maps all attributes of another instance into this object
  @override
  void mapFromOtherInstance(UserSpecificExerciseData other) {
    exerciseLinkID = other.exerciseLinkID;
    userID = other.userID;
    foundationId = other.foundationId;
    notes = other.notes;
    oneRepMax = other.oneRepMax;
  }

  // //////////////////////////////////////////////////////////////
  //                Getter                                      //
  // //////////////////////////////////////////////////////////////

  @override
  String getId() {
    return exerciseLinkID;
  }

  @override
  String getName() {
    return foundationId;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////
  @override
  Future<String> add() async {
    validateForAdd();
    //TODO: implement the add method
    return "";
  }

  @override
  Future<void> update() async {
    validateForUpdate();
    //TODO: implement the update method
  }

  @override
  Future<void> delete() async {
    validateForDelete();
    //TODO: implement the delete method
  }

// //////////////////////////////////////////////////////////////
//                Validation Methods                         //
// //////////////////////////////////////////////////////////////
  @override
  void validateForAdd() {
    //check if foundationId is empty
    if (foundationId.isEmpty) {
      throw Exception("The foundationId is empty");
    }

    //check if userID is empty
    if (userID.isEmpty) {
      throw Exception("The userID is empty");
    }
  }

  @override
  void validateForUpdate() {
    //check if excerciseLinkID is empty
    if (exerciseLinkID.isEmpty) {
      throw Exception("The excerciseLinkID is empty");
    }

    //check if userID is empty
    if (userID.isEmpty) {
      throw Exception("The userID is empty");
    }

    //check if foundationId is empty
    if (foundationId.isEmpty) {
      throw Exception("The foundationId is empty");
    }
  }

  @override
  void validateForDelete() {
    //check if excerciseLinkID is empty
    if (exerciseLinkID.isEmpty) {
      throw Exception("The excerciseLinkID is empty");
    }
  }
}
