import 'dart:math';

class TrainingCycleBus {
  /// Unique identifier for the training cycle
  String trainingCycleID;

  /// Name of the training cycle
  String cycleName;

  /// Detailed description of the training cycle
  String description;

  /// Focus or main goal of the training cycle
  String emphasis;

  /// Identifier of the user associated with this training cycle
  String userID;

  /// Start date of the training cycle
  DateTime beginDate;

  /// End date of the training cycle
  DateTime endDate;

  /// Optional: ID of the parent training cycle, if this is a sub-cycle
  String? parent;

  TrainingCycleBus({
    required this.trainingCycleID,
    required this.cycleName,
    required this.description,
    required this.emphasis,
    required this.userID,
    required this.beginDate,
    required this.endDate,
    this.parent,
  });

  ///factory method to create a training cycle from a data base object
  //TODO: implement the factory method

  ///method to convert the training cycle to a data base object
  //TODO: implement the toData method

  //maps all attributes of another instance into this object called mapFormOtherInstance
  void mapFromOtherInstance(TrainingCycleBus otherInstance) {
    trainingCycleID = otherInstance.trainingCycleID;
    cycleName = otherInstance.cycleName;
    description = otherInstance.description;
    emphasis = otherInstance.emphasis;
    userID = otherInstance.userID;
    beginDate = otherInstance.beginDate;
    endDate = otherInstance.endDate;
    parent = otherInstance.parent;
  }

  //resets every field of the training cycle to the default value
  void reset() {
    trainingCycleID = "";
    cycleName = "";
    description = "";
    emphasis = "";
    userID = "";
    beginDate = DateTime.now();
    endDate = DateTime.now();
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////

  //add a training cycle to the database
  //Future.error(Exception(e)) is used to return an error to the caller
  Future<void> addTrainingCycle() async {
    try {
      //TODO: implement the addTrainingCycle method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

  //update a training cycle in the database
  //Future.error(Exception(e)) is used to return an error to the caller
  Future<void> updateTrainingCycle() async {
    try {
      //TODO: implement the updateTrainingCycle method
    } on Exception catch (e) {
      int a = 0;
      return Future.error(Exception(e));
    }
  }

  //delete a training cycle from the database
  //Future.error(Exception(e)) is used to return an error to the caller
  Future<void> deleteTrainingCycle() async {
    try {
      //TODO: implement the deleteTrainingCycle method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

  // //////////////////////////////////////////////////////////////
  //                Validation Methods                         //
  // //////////////////////////////////////////////////////////////

  //validate the training cycle for add operation
  void validateForAdd() {
    //check if the begin date is before the end date
    if (beginDate.isAfter(endDate)) {
      throw Exception("The begin date is after the end date");
    }
    //check if the parent exists in the database
    if (parent != null) {
      //TODO: implement the check if parent exists
    }
    //check if begin date is after end date of parent
    if (parent != null) {
      //TODO: implement the check if begin date is after end date of parent
      //-> need to retrieve parent from database and check if begin date is after end date
    }
  }

  //validate the training cycle for update operation
  void validateForUpdate() {
    //TODO: implement validation of is the current working user
    //check if the begin date is before the end date
    if (beginDate.isAfter(endDate)) {
      throw Exception("The begin date is after the end date");
    }
    //check if the parent exists in the database
    if (parent != null) {
      //TODO: implement the check if parent exists
    }
    //check if begin date is after end date of parent
    if (parent != null) {
      //TODO: implement the check if begin date is after end date of parent
      //-> need to retrieve parent from database and check if begin date is after end date
    }
  }

  //validate the training cycle for delete operation
  void validateForDelete() {
    //TODO: implement validation of is the current working user
    //check if the id is empty
    if (trainingCycleID.isEmpty) {
      throw Exception("The training cycle id is empty");
    }
  }
}
