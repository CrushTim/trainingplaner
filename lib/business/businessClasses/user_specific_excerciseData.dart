import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

class UserSpecificExcerciseData
    implements TrainingsplanerBusInterface<UserSpecificExcerciseData> {
  ///the id of the user specific excercise data link
  String excerciseLinkID;

  ///the id of the user
  String userID;

  ///the foundation id the user has specific data for
  String foundationId;

  ///Notes the user has written for this excercise
  String notes;

  ///the current one Rep Max
  double oneRepMax;

  UserSpecificExcerciseData({
    required this.excerciseLinkID,
    required this.userID,
    required this.foundationId,
    required this.notes,
    required this.oneRepMax,
  });

  ///factory method to create a training cycle from a data base object
  //TODO: implement the factory method
  factory UserSpecificExcerciseData.fromData() {
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
    excerciseLinkID = "";
    userID = "";
    foundationId = "";
    notes = "";
    oneRepMax = 0;
  }

  ///maps all attributes of another instance into this object
  @override
  void mapFromOtherInstance(UserSpecificExcerciseData other) {
    excerciseLinkID = other.excerciseLinkID;
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
    return excerciseLinkID;
  }

  @override
  String getName() {
    return foundationId;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////
  @override
  Future<void> add() async {
    validateForAdd();
    //TODO: implement the add method
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
    if (excerciseLinkID.isEmpty) {
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
    if (excerciseLinkID.isEmpty) {
      throw Exception("The excerciseLinkID is empty");
    }
  }
}
