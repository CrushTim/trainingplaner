import 'package:trainingplaner/backend/dataClasses/training_cycle_data.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart'; // Add this import

class TrainingCycleBus
    implements TrainingsplanerBusInterface<TrainingCycleBus> {
  /// Unique identifier for the training cycle
  String trainingCycleID;

  /// Name of the training cycle
  String cycleName;

  /// Detailed description of the training cycle
  String description;

  /// Focus or main goal of the training cycle
  String emphasis;


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
    required this.beginDate,
    required this.endDate,
    this.parent,
  });

  ///factory method to create a training cycle from a data base object
  factory TrainingCycleBus.fromData(TrainingCycleData data) {
    return TrainingCycleBus(
      trainingCycleID: data.trainingCycleID,
      cycleName: data.cycleName,
      description: data.description,
      emphasis: data.emphasis,
      beginDate: data.beginDate,
      endDate: data.endDate,
      parent: data.parent,
    );
  }

  ///method to convert the training cycle to a data base object
  @override
  TrainingCycleData toData() {
    return TrainingCycleData(
      trainingCycleID: trainingCycleID,
      cycleName: cycleName,
      description: description,
      emphasis: emphasis,
      beginDate: beginDate,
      endDate: endDate,
      parent: parent,
    );
  }

  //maps all attributes of another instance into this object called mapFormOtherInstance
  @override
  void mapFromOtherInstance(TrainingCycleBus otherInstance) {
    trainingCycleID = otherInstance.trainingCycleID;
    cycleName = otherInstance.cycleName;
    description = otherInstance.description;
    emphasis = otherInstance.emphasis;
    beginDate = otherInstance.beginDate;
    endDate = otherInstance.endDate;
    parent = otherInstance.parent;
  }

  //resets every field of the training cycle to the default value
  @override
  void reset() {
    trainingCycleID = "";
    cycleName = "";
    description = "";
    emphasis = "";
    beginDate = DateTime.now();
    endDate = DateTime.now();
  }

  // //////////////////////////////////////////////////////////////
  //                Getter                                      //
  // //////////////////////////////////////////////////////////////

  @override
  String getId() {
    return trainingCycleID;
  }

  @override
  String getName() {
    return cycleName;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////

  //add a training cycle to the database
  //Future.error(Exception(e)) is used to return an error to the caller
  @override
  Future<String> add() async {
    validateForAdd();
    trainingCycleID = await toData().add();
    return trainingCycleID;
  }

  //update a training cycle in the database
  //Future.error(Exception(e)) is used to return an error to the caller
  @override
  Future<void> update() async {
    validateForUpdate();
    await toData().update();
  }

  //delete a training cycle from the database
  //Future.error(Exception(e)) is used to return an error to the caller
  @override
  Future<void> delete() async {
    validateForDelete();
    await toData().delete();
  }

  // //////////////////////////////////////////////////////////////
  //                Validation Methods                         //
  // //////////////////////////////////////////////////////////////

  //validate the training cycle for add operation
  @override
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
  @override
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
  @override
  void validateForDelete() {
    //TODO: implement validation of is the current working user
    //check if the id is empty
    if (trainingCycleID.isEmpty) {
      throw Exception("The training cycle id is empty");
    }
  }
}
