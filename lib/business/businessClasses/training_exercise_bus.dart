import 'package:trainingplaner/backend/dataClasses/training_exercise_data.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

class TrainingExerciseBus
    implements TrainingsplanerBusInterface<TrainingExerciseBus> {
  /// Unique identifier for the training exercise
  String trainingExerciseID;

  /// Name of the training exercise
  String exerciseName;

  /// Detailed description of the training exercise
  String exerciseDescription;

  /// the link to the underlying exercise in the database
  String exerciseFoundationID;

  /// the weights of the training exercise ordered by the set
  List<double> exerciseWeights;

  /// the reps of the training exercise ordered by the set
  List<int> exerciseReps;

  /// the target % of the 1RM for the exercise
  int targetPercentageOf1RM;

  ///declares whether the exercise is a planned one laying in the future
  ///or if it's a diary entry representing a past training session
  bool isPlanned;

  ///the date when the training exercise begins
  DateTime date;

  /// ID of the planned exercise this actual exercise is based on (null for planned exercises)
  String? plannedExerciseId;

  TrainingExerciseBus({
    required this.trainingExerciseID,
    required this.exerciseName,
    required this.exerciseDescription,
    required this.date,
    required this.exerciseFoundationID,
    required this.exerciseReps,
    required this.exerciseWeights,
    required this.isPlanned,
    required this.targetPercentageOf1RM,
    this.plannedExerciseId,
  });

  ///factory method to create a training exercise from a database object
  factory TrainingExerciseBus.fromData(TrainingExerciseData data) {
    return TrainingExerciseBus(
      trainingExerciseID: data.trainingExerciseID,
      exerciseName: data.exerciseName,
      exerciseDescription: data.exerciseDescription,
      date: data.date,
      exerciseFoundationID: data.exerciseFoundationID,
      exerciseReps: data.exerciseReps,
      exerciseWeights: data.exerciseWeights,
      isPlanned: data.isPlanned,
      targetPercentageOf1RM: data.targetPercentageOf1RM,
      plannedExerciseId: data.plannedExerciseId,
    );
  }

  ///method to convert the training exercise to a database object
  @override
  TrainingExerciseData toData() {
    return TrainingExerciseData(
      trainingExerciseID: trainingExerciseID,
      exerciseName: exerciseName,
      exerciseDescription: exerciseDescription,
      date: date,
      exerciseFoundationID: exerciseFoundationID,
      exerciseReps: exerciseReps,
      exerciseWeights: exerciseWeights,
      isPlanned: isPlanned,
      targetPercentageOf1RM: targetPercentageOf1RM,
      plannedExerciseId: plannedExerciseId,
    );
  }

  //maps all attributes of another instance into this object called mapFormOtherInstance
  @override
  void mapFromOtherInstance(TrainingExerciseBus otherInstance) {
    trainingExerciseID = otherInstance.trainingExerciseID;
    exerciseName = otherInstance.exerciseName;
    exerciseDescription = otherInstance.exerciseDescription;
    exerciseFoundationID = otherInstance.exerciseFoundationID;
    exerciseReps = otherInstance.exerciseReps;
    exerciseWeights = otherInstance.exerciseWeights;
    isPlanned = otherInstance.isPlanned;
    targetPercentageOf1RM = otherInstance.targetPercentageOf1RM;
  }

  //resets every field of the training exercise to the default value
  @override
  void reset() {
    trainingExerciseID = "";
    exerciseName = "";
    exerciseDescription = "";
    exerciseFoundationID = "";
    exerciseReps = [];
    exerciseWeights = [];
    isPlanned = false;
    targetPercentageOf1RM = 0;
  }

  // //////////////////////////////////////////////////////////////
  //                              Getter                         //
  // //////////////////////////////////////////////////////////////

  @override
  String getId() {
    return trainingExerciseID;
  }

  @override
  String getName() {
    return exerciseName;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////

  //add a training exercise to the database
  //Future.error(Exception(e)) is used to return an error to the caller
  @override
  Future<void> add() async {
    validateForAdd();
    toData().add();
  }

  //update a training exercise in the database
  //Future.error(Exception(e)) is used to return an error to the caller
  @override
  Future<void> update() async {
    validateForUpdate();
    toData().update();
  }

  //delete a training exercise from the database
  //Future.error(Exception(e)) is used to return an error to the caller
  @override
  Future<void> delete() async {
    validateForDelete();
    toData().delete();
  }

  // //////////////////////////////////////////////////////////////
  //                Validation Methods                         //
  // //////////////////////////////////////////////////////////////

  //validate the training exercise for add operation
  @override
  void validateForAdd() {
    //check if the weights and reps are of the same length
    if (exerciseWeights.length != exerciseReps.length) {
      throw Exception("The weights and reps are of different length");
    }

    //check if the weights are greater equals 0
    for (double weight in exerciseWeights) {
      if (weight < 0) {
        throw Exception("The weight is less than 0");
      }
    }

    //check if the reps are greater than 0
    for (int rep in exerciseReps) {
      if (rep <= 0) {
        throw Exception("The rep is less than or equal to 0");
      }
    }

    //check if the target percentage of 1RM is between 0 and 100
    if (targetPercentageOf1RM < 0 || targetPercentageOf1RM > 100) {
      throw Exception("The target percentage of 1RM is not between 0 and 100");
    }
  }

  //validate the training exercise for update operation
  @override
  void validateForUpdate() {
    //TODO: implement validation of is the current working user

    //check if the id is not empty
    if (trainingExerciseID.isEmpty) {
      throw Exception("The training exercise id is empty");
    }

    //check if the weights and reps are of the same length
    if (exerciseWeights.length != exerciseReps.length) {
      throw Exception("The weights and reps are of different length");
    }

    //check if the weights are greater equals 0
    for (double weight in exerciseWeights) {
      if (weight < 0) {
        throw Exception("The weight is less than 0");
      }
    }

    //check if the reps are greater than 0
    for (int rep in exerciseReps) {
      if (rep <= 0) {
        throw Exception("The rep is less than or equal to 0");
      }
    }

    //check if the target percentage of 1RM is between 0 and 100
    if (targetPercentageOf1RM < 0 || targetPercentageOf1RM > 100) {
      throw Exception("The target percentage of 1RM is not between 0 and 100");
    }
  }

  //validate the training exercise for delete operation
  @override
  void validateForDelete() {
    //TODO: implement validation of is the current working user

    //check if the id is not empty
    if (trainingExerciseID.isEmpty) {
      throw Exception("The training exercise id is empty");
    }
  }

  /// Create an actual exercise based on this planned exercise
  TrainingExerciseBus createActualExercise() {
    return TrainingExerciseBus(
      trainingExerciseID: "",
      exerciseName: this.exerciseName,
      exerciseDescription: this.exerciseDescription,
      date: this.date,
      exerciseFoundationID: this.exerciseFoundationID,
      exerciseReps: [],
      exerciseWeights: [],
      isPlanned: false,
      targetPercentageOf1RM: this.targetPercentageOf1RM,
      plannedExerciseId: this.trainingExerciseID,
    );
  }
}
