import 'package:trainingplaner/backend/dataClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

class UserSpecificExerciseBus
    implements TrainingsplanerBusInterface<UserSpecificExerciseBus> {
  ///the id of the user specific excercise data link
  String exerciseLinkID;

  ///the foundation id the user has specific data for
  String foundationId;

  ///the current one Rep Max
  double oneRepMax;

  ///the date of the last update
  DateTime date;

  UserSpecificExerciseBus({
    required this.exerciseLinkID,
    required this.foundationId,
    required this.oneRepMax,
    required this.date,
  });

  ///factory method to create a training cycle from a data base object
  factory UserSpecificExerciseBus.fromData(UserSpecificExerciseData data) {
    return UserSpecificExerciseBus(
      exerciseLinkID: data.exerciseLinkID,
      foundationId: data.foundationId,
      oneRepMax: data.oneRepMax,
      date: data.date,
    );
  }

  ///method to convert the training cycle to a data base object
  @override
  toData() {
    return UserSpecificExerciseData(
      exerciseLinkID: exerciseLinkID,
      foundationId: foundationId,
      oneRepMax: oneRepMax,
      date: date,
    );
  }

  ///resets every field of the training cycle to the default value
  @override
  void reset() {
    exerciseLinkID = "";
    foundationId = "";
    oneRepMax = 0;
    date = DateTime.now();
  }

  ///maps all attributes of another instance into this object
  @override
  void mapFromOtherInstance(UserSpecificExerciseBus other) {
    exerciseLinkID = other.exerciseLinkID;
    foundationId = other.foundationId;
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
  }

  @override
  void validateForUpdate() {
    //check if excerciseLinkID is empty
    if (exerciseLinkID.isEmpty) {
      throw Exception("The excerciseLinkID is empty");
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
