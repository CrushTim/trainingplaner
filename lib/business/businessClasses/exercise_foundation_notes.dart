
import 'package:trainingplaner/backend/dataClasses/exercise_foundation_notes_data.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

class ExerciseFoundationNotesBus implements TrainingsplanerBusInterface<ExerciseFoundationNotesBus> {
  String exerciseFoundationNotesId;
  List<String> exerciseFoundationNotes;
  String exerciseFoundationId;

  ExerciseFoundationNotesBus({required this.exerciseFoundationNotesId, required this.exerciseFoundationNotes, required this.exerciseFoundationId});

  factory ExerciseFoundationNotesBus.fromData(ExerciseFoundationNotesData data) {
    return ExerciseFoundationNotesBus(exerciseFoundationNotesId: data.exerciseFoundationNotesId, exerciseFoundationNotes: data.exerciseFoundationNotes, exerciseFoundationId: data.exerciseFoundationId);
  }

  @override
  ExerciseFoundationNotesData toData() {
    return ExerciseFoundationNotesData(exerciseFoundationNotesId: exerciseFoundationNotesId, exerciseFoundationNotes: exerciseFoundationNotes, exerciseFoundationId: exerciseFoundationId);
  }

  @override
  void reset() {
    exerciseFoundationNotesId = "";
    exerciseFoundationNotes = [];
    exerciseFoundationId = "";
  }

  @override
  void mapFromOtherInstance(ExerciseFoundationNotesBus other) {
    exerciseFoundationNotesId = other.exerciseFoundationNotesId;
    exerciseFoundationNotes = other.exerciseFoundationNotes;
    exerciseFoundationId = other.exerciseFoundationId;
  }

  // //////////////////////////////////////////////////////////////
  //                              Getter                         //
  // //////////////////////////////////////////////////////////////

  @override
  String getId() {
    return exerciseFoundationNotesId;
  }

  @override
  String getName() {
    return exerciseFoundationId;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////

  @override
  Future<String> add() async {
    return toData().add();
  }

  @override
  Future<void> update() async {
    await toData().update();
  }

  @override
  Future<void> delete() async {
    await toData().delete();
  }

  // //////////////////////////////////////////////////////////////
  //                              Validator                     //
  // //////////////////////////////////////////////////////////////

  @override
  void validateForAdd() {
    if(exerciseFoundationNotes.isEmpty) {
      throw Exception("The exercise foundation notes need at least one note");
    }
    if(exerciseFoundationId.isEmpty) {
      throw Exception("The exercise foundation notes need an exercise foundation id");
    }
  }

  @override
  void validateForUpdate() {
    if(exerciseFoundationNotesId.isEmpty) {
      throw Exception("The exercise foundation notes need an id");
    }
    if(exerciseFoundationNotes.isEmpty) {
      throw Exception("The exercise foundation notes need at least one note");
    }
    if(exerciseFoundationId.isEmpty) {
      throw Exception("The exercise foundation notes need an exercise foundation id");
    }
    validateForAdd();
  }

  @override
  void validateForDelete() {
    if(exerciseFoundationNotesId.isEmpty) {
      throw Exception("The exercise foundation notes need an id");
    }
  }
}
