class ExcerciseFoundationBus {
  ///represents the id of the excercise
  String excerciseFoundationId;

  ///represents the name of the excercise
  String excerciseFoundationName;

  ///represents the description of the excercise
  String excerciseFoundationDescription;

  ///represents the path of media connected to the excercise
  String excerciseFoundationPicturePath;

  ///represents the excercise type of the excercise
  List<String> excerciseFoundationCategories;

  ///represents the excercise foundation of the excercise
  List<String> excerciseFoundationMuscleGroups;

  ///represents the amount of people that are required to perform the excercise
  int excerciseFoundationAmountOfPeople;

  ///constructor of the excercise foundation
  ExcerciseFoundationBus({
    required this.excerciseFoundationId,
    required this.excerciseFoundationName,
    required this.excerciseFoundationDescription,
    required this.excerciseFoundationPicturePath,
    required this.excerciseFoundationCategories,
    required this.excerciseFoundationMuscleGroups,
    required this.excerciseFoundationAmountOfPeople,
  });

  ///factory method to create a training cycle from a data base object
  //TODO: implement the factory method

  ///method to convert the training cycle to a data base object
  //TODO: implement the toData method

  ///resets every field of the excercise foundation to the default value
  void reset() {
    excerciseFoundationId = "";
    excerciseFoundationName = "";
    excerciseFoundationDescription = "";
    excerciseFoundationPicturePath = "";
    excerciseFoundationCategories = [];
    excerciseFoundationMuscleGroups = [];
    excerciseFoundationAmountOfPeople = 0;
  }

  ///maps all attributes of another instance into this object
  void mapFromOtherInstance(ExcerciseFoundationBus other) {
    excerciseFoundationId = other.excerciseFoundationId;
    excerciseFoundationName = other.excerciseFoundationName;
    excerciseFoundationDescription = other.excerciseFoundationDescription;
    excerciseFoundationPicturePath = other.excerciseFoundationPicturePath;
    excerciseFoundationCategories = other.excerciseFoundationCategories;
    excerciseFoundationMuscleGroups = other.excerciseFoundationMuscleGroups;
    excerciseFoundationAmountOfPeople = other.excerciseFoundationAmountOfPeople;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////

  Future<void> addExcerciseFoundation() async {
    validateForAdd();
    try {
      //TODO: implement the addExcerciseFoundation method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

  Future<void> updateExcerciseFoundation() async {
    validateForUpdate();
    try {
      //TODO: implement the updateExcerciseFoundation method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

  Future<void> deleteExcerciseFoundation() async {
    validateForDelete();
    try {
      //TODO: implement the deleteExcerciseFoundation method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

  // //////////////////////////////////////////////////////////////
  //                Validation-Operations                           //
  // //////////////////////////////////////////////////////////////

  ///validates the excercise foundation for add operations
  void validateForAdd() {
    //check if the excercise got a name
    if (excerciseFoundationName.isEmpty) {
      throw Exception("The excercise needs a name");
    }

    //check if the categories are not empty
    if (excerciseFoundationCategories.isEmpty) {
      throw Exception("The excercise needs at least one category");
    }
  }

  ///validates the excercise foundation for update operations
  void validateForUpdate() {
    //check if the id is not empty
    if (excerciseFoundationId.isEmpty) {
      throw Exception("The excercise needs an id");
    }

    //check if the excercise got a name
    if (excerciseFoundationName.isEmpty) {
      throw Exception("The excercise needs a name");
    }

    //check if the categories are not empty
    if (excerciseFoundationCategories.isEmpty) {
      throw Exception("The excercise needs at least one category");
    }
  }

  void validateForDelete() {
    //check if the id is not empty
    if (excerciseFoundationId.isEmpty) {
      throw Exception("The excercise needs an id");
    }
  }
}
