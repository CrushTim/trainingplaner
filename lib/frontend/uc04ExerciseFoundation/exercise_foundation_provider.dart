import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_notes.dart';
import 'package:trainingplaner/business/businessClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/business/reports/excercise_foundation_bus_report.dart';
import 'package:trainingplaner/business/reports/exercise_foundation_notes_bus_report.dart';
import 'package:trainingplaner/business/reports/user_specific_exercise_data_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_list_tile.dart';

class ExerciseFoundationProvider extends TrainingsplanerProvider<ExerciseFoundationBus, ExerciseFoundationBusReport> {
  ExerciseFoundationProvider() : super(
    businessClassForAdd: ExerciseFoundationBus(
      exerciseFoundationId: "",
      exerciseFoundationName: "",
      exerciseFoundationDescription: "",
      exerciseFoundationPicturePath: "",
      exerciseFoundationCategories: [],
      exerciseFoundationMuscleGroups: [],
      exerciseFoundationAmountOfPeople: 1,
    ),
    reportTaskVar: ExerciseFoundationBusReport(),
  );

  ExerciseFoundationProvider mapToNewInstance() {
    ExerciseFoundationProvider newInstance = ExerciseFoundationProvider();
    newInstance.businessClassForAdd = businessClassForAdd;
    newInstance.reportTaskVar = reportTaskVar;
    newInstance.userSpecificExercise = userSpecificExercise;
    newInstance.selectedUserSpecificExercise = selectedUserSpecificExercise;
    newInstance.userSpecificExerciseBusForAdd = userSpecificExerciseBusForAdd;
    newInstance.oneRepMaxController = oneRepMaxController;
    return newInstance;
  }

  UserSpecificExerciseDataBusReport userSpecificExerciseDataReport = UserSpecificExerciseDataBusReport();

  List<UserSpecificExerciseBus> userSpecificExercise = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController picturePathController = TextEditingController();
  final TextEditingController categoriesController = TextEditingController();
  final TextEditingController muscleGroupsController = TextEditingController();
  final TextEditingController amountOfPeopleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();


  void initState() {
    if (getSelectedBusinessClass != null) {
      nameController.text = getSelectedBusinessClass!.exerciseFoundationName;
      descriptionController.text = getSelectedBusinessClass!.exerciseFoundationDescription;
      picturePathController.text = getSelectedBusinessClass!.exerciseFoundationPicturePath;
      categoriesController.text = getSelectedBusinessClass!.exerciseFoundationCategories.join(', ');
      muscleGroupsController.text = getSelectedBusinessClass!.exerciseFoundationMuscleGroups.join(', ');
      amountOfPeopleController.text = getSelectedBusinessClass!.exerciseFoundationAmountOfPeople.toString();
      notesController.text = getSelectedBusinessClass!.exerciseFoundationNotes?.exerciseFoundationNotes.join(', ') ?? "";
    } else {
      nameController.text = businessClassForAdd.exerciseFoundationName;
      descriptionController.text = businessClassForAdd.exerciseFoundationDescription;
      picturePathController.text = businessClassForAdd.exerciseFoundationPicturePath;
      categoriesController.text = businessClassForAdd.exerciseFoundationCategories.join(', ');
      muscleGroupsController.text = businessClassForAdd.exerciseFoundationMuscleGroups.join(', ');
      amountOfPeopleController.text = businessClassForAdd.exerciseFoundationAmountOfPeople.toString();
      notesController.text = businessClassForAdd.exerciseFoundationNotes?.exerciseFoundationNotes.join(', ') ?? "";
    }
  }

  void handleTextFieldChange(String field, String value) {
    ExerciseFoundationBus target = getSelectedBusinessClass ?? businessClassForAdd;
    switch (field) {
      case 'name':
        target.exerciseFoundationName = value;
        break;
      case 'description':
        target.exerciseFoundationDescription = value;
        break;
      case 'picturePath':
        target.exerciseFoundationPicturePath = value;
        break;
      case 'categories':
        target.exerciseFoundationCategories = value.split(',').map((e) => e.trim()).toList();
        break;
      case 'muscleGroups':
        target.exerciseFoundationMuscleGroups = value.split(',').map((e) => e.trim()).toList();
        break;
      case 'amountOfPeople':
        target.exerciseFoundationAmountOfPeople = int.tryParse(value) ?? 1;
        break;
      case 'notes':
        target.exerciseFoundationNotes = ExerciseFoundationNotesBus(exerciseFoundationNotesId: "", exerciseFoundationNotes: value.split(',').map((e) => e.trim()).toList(), exerciseFoundationId: target.getId());
        break;
    }
    notifyListeners();
  }

  Future<void> saveExerciseFoundation(ScaffoldMessengerState scaffoldMessengerState) async {
    if (getSelectedBusinessClass != null) {
      await updateBusinessClass(getSelectedBusinessClass!, scaffoldMessengerState);
    } else {
      await addBusinessClass(businessClassForAdd, scaffoldMessengerState);
    }
  }

  // /////////////////////////////////////////////////////////////////////
  //                         View Methods
  // /////////////////////////////////////////////////////////////////////

  ExerciseFoundationNotesBusReport exerciseFoundationNotesBusReport = ExerciseFoundationNotesBusReport();

  StreamBuilder3 getAllExerciseFoundationsWithUserLinks() {
    return StreamBuilder3(
      streams: StreamTuple3(reportTaskVar.getAll(), userSpecificExerciseDataReport.getAll(), exerciseFoundationNotesBusReport.getAll()),
      builder: (context, snapshots) {
        if (snapshots.snapshot1.connectionState == ConnectionState.waiting || snapshots.snapshot2.connectionState == ConnectionState.waiting || snapshots.snapshot2.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshots.snapshot1.hasError || snapshots.snapshot2.hasError || snapshots.snapshot3.hasError) {
          return Text(snapshots.snapshot1.error.toString() + snapshots.snapshot2.error.toString() + snapshots.snapshot3.error.toString());
        } else {
          List<ExerciseFoundationBus> exerciseFoundations = snapshots.snapshot1.data!;
          List<UserSpecificExerciseBus> userSpecificExercises = snapshots.snapshot2.data!;
          List<ExerciseFoundationNotesBus> exerciseFoundationNotes = snapshots.snapshot3.data!;
          

          Map<String, List<UserSpecificExerciseBus>> userSpecificMap = {};
          Map<String, ExerciseFoundationNotesBus> notesMap = {};
          
          // Build maps once
          for (var exercise in userSpecificExercises) {
            userSpecificMap.putIfAbsent(exercise.foundationId, () => []).add(exercise);
          }
          
          for (var note in exerciseFoundationNotes) {
            notesMap[note.exerciseFoundationId] = note;
          }
          
          return Column(
            children: exerciseFoundations.map((exerciseFoundation) {
              String id = exerciseFoundation.getId();
              
              
              exerciseFoundation.userSpecific1RepMaxes = userSpecificMap[id] ?? [];
              exerciseFoundation.exerciseFoundationNotes = notesMap[id];
              
              return ExerciseFoundationListTile(exerciseFoundation: exerciseFoundation);
            }).toList().cast<Widget>(),
          );
        }
      },
    );
  }


  // /////////////////////////////////////////////////////////////////////
  //                 One Rep Max Methods        
  // /////////////////////////////////////////////////////////////////////

  UserSpecificExerciseBus? selectedUserSpecificExercise;

  UserSpecificExerciseBus userSpecificExerciseBusForAdd = UserSpecificExerciseBus(
    exerciseLinkID: "",
    oneRepMax: 0,
    foundationId: "",
    date: DateTime.now(),
  );

  void setSelectedUserSpecificExercise(UserSpecificExerciseBus userSpecificExercise) {
    selectedUserSpecificExercise = userSpecificExercise;
  }

  void resetSelectedUserSpecificExercise() {
    print("reset");
    selectedUserSpecificExercise = null;
  }

  void resetUserSpecificExerciseForAdd() {
    print("add");
    userSpecificExerciseBusForAdd = UserSpecificExerciseBus(
      exerciseLinkID: "",
      oneRepMax: 0,
      foundationId: "",
      date: DateTime.now(),
    );
  }

  TextEditingController oneRepMaxController = TextEditingController();
  DateTime initialDateTime = DateTime.now();


  void initStateUserSpecificExercise() {
    if (selectedUserSpecificExercise != null) {
      oneRepMaxController.text = selectedUserSpecificExercise!.oneRepMax.toString();
      initialDateTime = selectedUserSpecificExercise!.date;
    }
    else {
      oneRepMaxController.text = "";
    }
  }

  void handleTextFieldChangeUserSpecificExercise(String field, String value) {
    UserSpecificExerciseBus target = selectedUserSpecificExercise ?? userSpecificExerciseBusForAdd;
    switch (field) {
      case 'oneRepMax':
        target.oneRepMax = double.parse(value);
        break;
    }
  }

  void onDateTimeChangedUserSpecificExercise(DateTime dateTime) {
    UserSpecificExerciseBus target = selectedUserSpecificExercise ?? userSpecificExerciseBusForAdd;
    target.date = dateTime;
  }

  Future<void> saveUserSpecificExercise(ScaffoldMessengerState scaffoldMessengerState) async {
    if (selectedUserSpecificExercise != null) {
      await updateUserSpecificExercise(selectedUserSpecificExercise!, scaffoldMessengerState);
    } else {
      await addUserSpecificExercise(userSpecificExerciseBusForAdd, scaffoldMessengerState);
    }
  }


  // /////////////////////////////////////////////////////////////////////
  //                 User Specific Exercise CRUD-Methods
  // /////////////////////////////////////////////////////////////////////

  Future<void> addUserSpecificExercise(
    UserSpecificExerciseBus exercise,
    ScaffoldMessengerState scaffoldMessengerState, {
    bool notify = true,
  }) async {
    String message = "Added ${exercise.getName()}";
    try {
      await exercise.add()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      resetUserSpecificExerciseForAdd();
      if (notify) {
        notifyListeners();
      }

      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> updateUserSpecificExercise(
    UserSpecificExerciseBus exercise,
    ScaffoldMessengerState scaffoldMessengerState, {
    bool notify = true,
  }) async {
    String message = "Updated ${exercise.getName()}";
    try {
      await exercise.update()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> deleteUserSpecificExercise(
    UserSpecificExerciseBus exercise,
    ScaffoldMessengerState scaffoldMessengerState, {
    bool notify = true,
  }) async {
    String message = "Deleted ${exercise.getName()}";
    try {
      await exercise.delete()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // /////////////////////////////////////////////////////////////////////
  //                 Notes Methods
  // /////////////////////////////////////////////////////////////////////

  ExerciseFoundationNotesBus exerciseFoundationNotesBusForAdd = ExerciseFoundationNotesBus(
    exerciseFoundationNotesId: "",
    exerciseFoundationNotes: [],
    exerciseFoundationId: "",
  );

  ExerciseFoundationNotesBus? selectedExerciseFoundationNotes;


  // /////////////////////////////////////////////////////////////////////
  //                 NOTES CRUD-Methods
  // /////////////////////////////////////////////////////////////////////

  Future<void> addExerciseFoundationNotes(
    ExerciseFoundationNotesBus notes,
    ScaffoldMessengerState scaffoldMessengerState, {
    bool notify = true,
  }) async {
    String message = "Added Notes";
    try {
      await notes.add()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> updateExerciseFoundationNotes(
    ExerciseFoundationNotesBus notes,
    ScaffoldMessengerState scaffoldMessengerState, {
    bool notify = true,
  }) async {
    String message = "Updated Notes";
    try {
      await notes.update()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> deleteExerciseFoundationNotes(
    ExerciseFoundationNotesBus notes,
    ScaffoldMessengerState scaffoldMessengerState, {
    bool notify = true,
  }) async {
    String message = "Deleted Notes";
    try {
      await notes.delete()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
  
}
