import 'package:trainingplaner/backend/dataClasses/exercise_foundation_data.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

class ExerciseFoundationBus
    implements TrainingsplanerBusInterface<ExerciseFoundationBus> {
  ///represents the id of the exercise
  String exerciseFoundationId;

  ///represents the name of the exercise
  String exerciseFoundationName;

  ///represents the description of the exercise
  String exerciseFoundationDescription;

  ///represents the path of media connected to the exercise
  String exerciseFoundationPicturePath;

  ///represents the exercise type of the exercise
  List<String> exerciseFoundationCategories;

  ///represents the exercise foundation of the exercise
  List<String> exerciseFoundationMuscleGroups;

  ///represents the amount of people that are required to perform the exercise
  int exerciseFoundationAmountOfPeople;

  ///constructor of the exercise foundation
  ExerciseFoundationBus({
    required this.exerciseFoundationId,
    required this.exerciseFoundationName,
    required this.exerciseFoundationDescription,
    required this.exerciseFoundationPicturePath,
    required this.exerciseFoundationCategories,
    required this.exerciseFoundationMuscleGroups,
    required this.exerciseFoundationAmountOfPeople,
  });

  /// Creates an ExerciseFoundationBus instance from a data object
  factory ExerciseFoundationBus.fromData(ExerciseFoundationData data) {
    return ExerciseFoundationBus(
      exerciseFoundationId: data.exerciseFoundationId,
      exerciseFoundationName: data.exerciseFoundationName,
      exerciseFoundationDescription: data.exerciseFoundationDescription,
      exerciseFoundationPicturePath: data.exerciseFoundationPicturePath,
      exerciseFoundationCategories: data.exerciseFoundationCategories,
      exerciseFoundationMuscleGroups: data.exerciseFoundationMuscleGroups,
      exerciseFoundationAmountOfPeople: data.exerciseFoundationAmountOfPeople,
    );
  }

  /// Converts the ExerciseFoundationBus instance to a data object
  @override
  ExerciseFoundationData toData() {
    return ExerciseFoundationData(
      exerciseFoundationId: exerciseFoundationId,
      exerciseFoundationName: exerciseFoundationName,
      exerciseFoundationDescription: exerciseFoundationDescription,
      exerciseFoundationPicturePath: exerciseFoundationPicturePath,
      exerciseFoundationCategories: exerciseFoundationCategories,
      exerciseFoundationMuscleGroups: exerciseFoundationMuscleGroups,
      exerciseFoundationAmountOfPeople: exerciseFoundationAmountOfPeople,
    );
  }

  ///resets every field of the exercise foundation to the default value
  @override
  void reset() {
    exerciseFoundationId = "";
    exerciseFoundationName = "";
    exerciseFoundationDescription = "";
    exerciseFoundationPicturePath = "";
    exerciseFoundationCategories = [];
    exerciseFoundationMuscleGroups = [];
    exerciseFoundationAmountOfPeople = 0;
  }

  ///maps all attributes of another instance into this object
  @override
  void mapFromOtherInstance(ExerciseFoundationBus other) {
    exerciseFoundationId = other.exerciseFoundationId;
    exerciseFoundationName = other.exerciseFoundationName;
    exerciseFoundationDescription = other.exerciseFoundationDescription;
    exerciseFoundationPicturePath = other.exerciseFoundationPicturePath;
    exerciseFoundationCategories = other.exerciseFoundationCategories;
    exerciseFoundationMuscleGroups = other.exerciseFoundationMuscleGroups;
    exerciseFoundationAmountOfPeople = other.exerciseFoundationAmountOfPeople;
  }

  // //////////////////////////////////////////////////////////////
  //                              Getter                         //
  // //////////////////////////////////////////////////////////////

  @override
  String getId() {
    return exerciseFoundationId;
  }

  @override
  String getName() {
    return exerciseFoundationName;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////

  @override
  Future<String> add() async {
    validateForAdd();
    String id = await toData().add();
    exerciseFoundationId = id;
    return id;
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
  //                Validation-Operations                           //
  // //////////////////////////////////////////////////////////////

  ///validates the exercise foundation for add operations
  @override
  void validateForAdd() {
    //check if the exercise got a name
    if (exerciseFoundationName.isEmpty) {
      throw Exception("The exercise needs a name");
    }

    //check if the categories are not empty
    if (exerciseFoundationCategories.isEmpty) {
      throw Exception("The exercise needs at least one category");
    }
  }

  ///validates the exercise foundation for update operations
  @override
  void validateForUpdate() {
    //check if the id is not empty
    if (exerciseFoundationId.isEmpty) {
      throw Exception("The exercise needs an id");
    }

    //check if the exercise got a name
    if (exerciseFoundationName.isEmpty) {
      throw Exception("The exercise needs a name");
    }

    //check if the categories are not empty
    if (exerciseFoundationCategories.isEmpty) {
      throw Exception("The exercise needs at least one category");
    }
  }

  @override
  void validateForDelete() {
    //check if the id is not empty
    if (exerciseFoundationId.isEmpty) {
      throw Exception("The exercise needs an id");
    }
  }
}
