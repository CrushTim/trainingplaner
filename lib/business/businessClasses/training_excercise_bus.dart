class TrainingExcerciseBus {
  /// Unique identifier for the training excercise
  String trainingExcerciseID;

  /// Name of the training excercise
  String excerciseName;

  /// Detailed description of the training excercise
  String excerciseDescription;

  /// the link to the underlying excercise in the database
  String excerciseFoundationID;

  /// the weights of the training excercise ordered by the set
  List<double> excerciseWeights;

  /// the reps of the training excercise ordered by the set
  List<int> excerciseReps;

  /// the target % of the 1RM for the excercise
  int targetPercentageOf1RM;

  ///declares wether the excercise is a planned one laying in the future
  ///or if its a diary entry representing a past training session
  bool isPlanned;

  ///the date when the training excercise begins
  DateTime date;

  TrainingExcerciseBus({
    required this.trainingExcerciseID,
    required this.excerciseName,
    required this.excerciseDescription,
    required this.date,
    required this.excerciseFoundationID,
    required this.excerciseReps,
    required this.excerciseWeights,
    required this.isPlanned,
    required this.targetPercentageOf1RM,
  });

  ///factory method to create a training excercise from a data base object
  //TODO: implement the factory method

  ///method to convert the training excercise to a data base object
  //TODO: implement the toData method

  //maps all attributes of another instance into this object called mapFormOtherInstance
  void mapFromOtherInstance(TrainingExcerciseBus otherInstance) {
    trainingExcerciseID = otherInstance.trainingExcerciseID;
    excerciseName = otherInstance.excerciseName;
    excerciseDescription = otherInstance.excerciseDescription;
    excerciseFoundationID = otherInstance.excerciseFoundationID;
    excerciseReps = otherInstance.excerciseReps;
    excerciseWeights = otherInstance.excerciseWeights;
    isPlanned = otherInstance.isPlanned;
    targetPercentageOf1RM = otherInstance.targetPercentageOf1RM;
  }

  //resets every field of the training excercise to the default value
  void reset() {
    trainingExcerciseID = "";
    excerciseName = "";
    excerciseDescription = "";
    excerciseFoundationID = "";
    excerciseReps = [];
    excerciseWeights = [];
    isPlanned = false;
    targetPercentageOf1RM = 0;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////

  //add a training excercise to the database
  //Future.error(Exception(e)) is used to return an error to the caller
  Future<void> addTrainingExcercise() async {
    try {
      //TODO: implement the addTrainingExcercise method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

  //update a training excercise in the database
  //Future.error(Exception(e)) is used to return an error to the caller
  Future<void> updateTrainingExcercise() async {
    try {
      //TODO: implement the updateTrainingExcercise method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

  //delete a training excercise from the database
  //Future.error(Exception(e)) is used to return an error to the caller
  Future<void> deleteTrainingExcercise() async {
    try {
      //TODO: implement the deleteTrainingExcercise method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

  // //////////////////////////////////////////////////////////////
  //                Validation Methods                         //
  // //////////////////////////////////////////////////////////////

  //validate the training excercise for add operation
  void validateForAdd() {
    //check if the weights and reps are of the same length
    if (excerciseWeights.length != excerciseReps.length) {
      throw Exception("The weights and reps are of different length");
    }

    //check if the weights are greater equals 0
    for (double weight in excerciseWeights) {
      if (weight < 0) {
        throw Exception("The weight is less than 0");
      }
    }

    //check if the reps are greater then 0
    for (int rep in excerciseReps) {
      if (rep <= 0) {
        throw Exception("The rep is less than 0");
      }
    }

    //check if the target percentage of 1RM is between 0 and 100
    if (targetPercentageOf1RM < 0 || targetPercentageOf1RM > 100) {
      throw Exception("The target percentage of 1RM is not between 0 and 100");
    }
  }

  //validate the training excercise for update operation
  void validateForUpdate() {
    //TODO: implement validation of is the current working user

    //chekc if the id is not empty
    if (trainingExcerciseID.isEmpty) {
      throw Exception("The training excercise id is empty");
    }

    //check if the weights and reps are of the same length
    if (excerciseWeights.length != excerciseReps.length) {
      throw Exception("The weights and reps are of different length");
    }

    //check if the weights are greater equals 0
    for (double weight in excerciseWeights) {
      if (weight < 0) {
        throw Exception("The weight is less than 0");
      }
    }

    //check if the reps are greater then 0
    for (int rep in excerciseReps) {
      if (rep <= 0) {
        throw Exception("The rep is less than 0");
      }
    }

    //check if the target percentage of 1RM is between 0 and 100
    if (targetPercentageOf1RM < 0 || targetPercentageOf1RM > 100) {
      throw Exception("The target percentage of 1RM is not between 0 and 100");
    }
  }

  //validate the training excercise for delete operation
  void validateForDelete() {
    //TODO: implement validation of is the current working user

    //check if the id is not empty
    if (trainingExcerciseID.isEmpty) {
      throw Exception("The training excercise id is empty");
    }
  }
}
