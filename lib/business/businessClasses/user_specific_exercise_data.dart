import 'package:trainingplaner/backend/dataClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

class UserSpecificExerciseBus
    implements TrainingsplanerBusInterface<UserSpecificExerciseBus> {
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

  UserSpecificExerciseBus({
    required this.exerciseLinkID,
    required this.userID,
    required this.foundationId,
    required this.notes,
    required this.oneRepMax,
  });

  ///factory method to create a training cycle from a data base object
  factory UserSpecificExerciseBus.fromData(UserSpecificExerciseData data) {
    return UserSpecificExerciseBus(
      exerciseLinkID: data.exerciseLinkID,
      userID: data.userID,
      foundationId: data.foundationId,
      notes: data.notes,
      oneRepMax: data.oneRepMax,
    );
  }

  ///method to convert the training cycle to a data base object
  @override
  toData() {
    return UserSpecificExerciseData(
      exerciseLinkID: exerciseLinkID,
      userID: userID,
      foundationId: foundationId,
      notes: notes,
      oneRepMax: oneRepMax,
    );
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
  void mapFromOtherInstance(UserSpecificExerciseBus other) {
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
    exerciseLinkID = await toData().add();
    return exerciseLinkID;
  }

  @override
  Future<void> update() async {
    validateForUpdate();
    await toData().update();
  }

  @override
  Future<void> delete() async {
    validateForDelete();
    await toData().delete();
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
