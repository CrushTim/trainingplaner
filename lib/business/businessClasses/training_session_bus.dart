import 'package:trainingplaner/backend/dataClasses/training_session_data.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
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
  ///the list is used to map the exercises from the the exercise report into the
  ///trainingSessionExercises list in this bus
  List<String> trainingSessionExcercisesIds;

  ///represents the list of the training session exercises
  ///this List is changed in the perspective by maping the trainingSessionExcercisesIds
  ///to the trainingSessionExercises in the exercise report
  List<TrainingExerciseBus> trainingSessionExercises = [];

  ///represents the emphasis of the training session
  List<String> trainingSessionEmphasis;

  ///wether the training session is a planned one or one that is a diary entry
  bool isPlanned;

  ///the cycle the session is in
  String trainingCycleId;

  /// ID of the planned session this actual session is based on (null for planned sessions)
  String? plannedSessionId;

  ///constructor of the training cycle
  TrainingSessionBus({
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
  });

  ///factory method to create a training cycle from a data base object
  factory TrainingSessionBus.fromData(TrainingSessionData data) {
    return TrainingSessionBus(
      trainingSessionId: data.trainingSessionId,
      trainingSessionName: data.trainingSessionName,
      trainingSessionDescription: data.trainingSessionDescription,
      trainingSessionStartDate: data.trainingSessionStartDate,
      trainingSessionLength: data.trainingSessionLength,
      trainingSessionExcercisesIds: data.trainingSessionExcercisesIds,
      trainingSessionEmphasis: data.trainingSessionEmphasis,
      isPlanned: data.isPlanned,
      trainingCycleId: data.trainingCycleId,
      plannedSessionId: data.plannedSessionId,
    );
  }

  ///method to convert the training cycle to a data base object
  @override
  TrainingSessionData toData() {
    return TrainingSessionData(
      trainingSessionId: trainingSessionId,
      trainingSessionName: trainingSessionName,
      trainingSessionDescription: trainingSessionDescription,
      trainingSessionStartDate: trainingSessionStartDate,
      trainingSessionLength: trainingSessionLength,
      trainingSessionExcercisesIds: trainingSessionExcercisesIds,
      trainingSessionEmphasis: trainingSessionEmphasis,
      isPlanned: isPlanned,
      trainingCycleId: trainingCycleId,
      plannedSessionId: plannedSessionId,
    );
  }

  ///resets every field of the training cycle to the default value
  @override
  void reset() {
    trainingSessionId = "";
    trainingSessionName = "";
    trainingSessionDescription = "";
    trainingSessionStartDate = DateTime.now();
    trainingSessionLength = 1;
    trainingSessionExcercisesIds = [];
    trainingSessionEmphasis = [];
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
    trainingSessionExcercisesIds = other.trainingSessionExcercisesIds;
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
  Future<String> add() async {
    validateForAdd();
    trainingSessionId = await toData().add();
    return trainingSessionId;
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
    if (trainingSessionName.isEmpty) {
      throw Exception("The training session name is empty");
    }
    if (trainingSessionLength < 1) {
      throw Exception("The training session length is less than 1");
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
  }

  @override
  void validateForDelete() {
    if (trainingSessionId.isEmpty) {
      throw Exception("The training session id is empty");
    }
  }

  /// Create an actual session based on this planned session
  TrainingSessionBus createActualSession() {
    return TrainingSessionBus(
      trainingSessionId: "",
      trainingSessionName: trainingSessionName,
      trainingSessionDescription: trainingSessionDescription,
      trainingSessionStartDate: DateTime.now(),
      trainingSessionLength: trainingSessionLength,
      trainingSessionExcercisesIds: [],
      trainingSessionEmphasis: trainingSessionEmphasis,
      isPlanned: false,
      trainingCycleId: trainingCycleId,
      plannedSessionId: trainingSessionId,
    );
  }

  String toString() {
    return "TrainingSessionBus(trainingSessionId: $trainingSessionId, trainingSessionName: $trainingSessionName, trainingSessionDescription: $trainingSessionDescription, trainingSessionStartDate: $trainingSessionStartDate, trainingSessionLength: $trainingSessionLength, trainingSessionExcercisesIds: $trainingSessionExcercisesIds, trainingSessionEmphasis: $trainingSessionEmphasis, isPlanned: $isPlanned, trainingCycleId: $trainingCycleId, plannedSessionId: $plannedSessionId)";
  }
}
