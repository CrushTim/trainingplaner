import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

class TrainingSessionBus
    implements TrainingsplanerBusInterface<TrainingSessionBus> {
  ///represents the id of the training session
  String trainingSessionId;

  ///represents the name of the training session
  String trainingSessionName;

  ///represents the description of the training session
  String trainingSessionDescription;

  ///represents the start date of the training session
  DateTime trainingSessionStartDate;

  ///represents the end date of the training session
  int trainingSessionLength;

  ///represents the excercises as a list of ids of the training session
  List<String> trainingSessionExcercises;

  ///represents the emphasis of the training session
  String trainingSessionEmphasis;

  ///wether the training session is a planned one or one that is a diary entry
  bool isPlanned;

  ///the cycle the session is in
  String trainingCycleId;

  ///constructor of the training cycle
  TrainingSessionBus({
    required this.trainingSessionId,
    required this.trainingSessionName,
    required this.trainingSessionDescription,
    required this.trainingSessionStartDate,
    required this.trainingSessionLength,
    required this.trainingSessionExcercises,
    required this.trainingSessionEmphasis,
    required this.isPlanned,
    required this.trainingCycleId,
  });

  ///factory method to create a training cycle from a data base object
  //TODO: implement the factory method
  factory TrainingSessionBus.fromData() {
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
    trainingSessionId = "";
    trainingSessionName = "";
    trainingSessionDescription = "";
    trainingSessionStartDate = DateTime.now();
    trainingSessionLength = 1;
    trainingSessionExcercises = [];
    trainingSessionEmphasis = "";
    isPlanned = true;
    trainingCycleId = "";
  }

  ///maps all attributes of another instance into this object
  @override
  void mapFromOtherInstance(TrainingSessionBus other) {
    trainingSessionId = other.trainingSessionId;
    trainingSessionName = other.trainingSessionName;
    trainingSessionDescription = other.trainingSessionDescription;
    trainingSessionStartDate = other.trainingSessionStartDate;
    trainingSessionLength = other.trainingSessionLength;
    trainingSessionExcercises = other.trainingSessionExcercises;
    trainingSessionEmphasis = other.trainingSessionEmphasis;
    isPlanned = other.isPlanned;
    trainingCycleId = other.trainingCycleId;
  }

  // //////////////////////////////////////////////////////////////
  //                Getter                                      //
  // //////////////////////////////////////////////////////////////

  @override
  String getId() {
    return trainingSessionId;
  }

  @override
  String getName() {
    return trainingSessionName;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////

  @override
  Future<void> add() async {
    validateForAdd();
    //TODO: implement the addTrainingCycle method
  }

  @override
  Future<void> update() async {
    validateForUpdate();
    //TODO: implement the updateTrainingCycle method
  }

  @override
  Future<void> delete() async {
    validateForDelete();
    //TODO: implement the deleteTrainingCycle method
  }

  // //////////////////////////////////////////////////////////////
  //                Validation Methods                         //
  // //////////////////////////////////////////////////////////////

  @override
  void validateForAdd() {
    if (trainingSessionName.isEmpty) {
      throw Exception("The training session name is empty");
    }
    if (trainingSessionLength < 1) {
      throw Exception("The training session length is less than 1");
    }
    if (trainingSessionExcercises.isEmpty) {
      throw Exception("The training session excercises are empty");
    }
    //TODO: implement validation of is in training cycle(maybe in provider)
  }

  @override
  void validateForUpdate() {
    if (trainingSessionId.isEmpty) {
      throw Exception("The training session id is empty");
    }
    if (trainingSessionName.isEmpty) {
      throw Exception("The training session name is empty");
    }
    if (trainingSessionLength < 1) {
      throw Exception("The training session length is less than 1");
    }
    if (trainingSessionExcercises.isEmpty) {
      throw Exception("The training session excercises are empty");
    }
  }

  @override
  void validateForDelete() {
    if (trainingSessionId.isEmpty) {
      throw Exception("The training session id is empty");
    }
  }
}
