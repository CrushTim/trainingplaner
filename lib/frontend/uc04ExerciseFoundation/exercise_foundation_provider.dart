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
  List<ExerciseFoundationBus> loadedFoundations = [];
  bool isLoading = false;
  bool hasMoreData = true;
  int currentIndex = 0;
  int pageSize = 10;

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
        String id = target.exerciseFoundationNotes?.exerciseFoundationNotesId ?? "";
        target.exerciseFoundationNotes = ExerciseFoundationNotesBus(exerciseFoundationNotesId: id, exerciseFoundationNotes: value.split(',').map((e) => e.trim()).toList(), exerciseFoundationId: target.getId());
        break;
    }
  }

  Future<void> saveExerciseFoundation(ScaffoldMessengerState scaffoldMessengerState) async {
    ExerciseFoundationNotesBus? targetNotes;
    ExerciseFoundationBus target = getSelectedBusinessClass ?? businessClassForAdd;
    String addId = "";
    if (getSelectedBusinessClass != null) {
      targetNotes = getSelectedBusinessClass!.exerciseFoundationNotes;
      await updateBusinessClass(getSelectedBusinessClass!, scaffoldMessengerState);
    } else {
      targetNotes = businessClassForAdd.exerciseFoundationNotes;
      addId = await addBusinessClass(businessClassForAdd, scaffoldMessengerState);
    }


    if(targetNotes != null) {
      targetNotes.exerciseFoundationId = getSelectedBusinessClass == null ? addId : getSelectedBusinessClass!.getId();
      
      if(notesMap[target.getId()] == null) {
        await addExerciseFoundationNotes(targetNotes, scaffoldMessengerState);
      } else {
        await updateExerciseFoundationNotes(targetNotes, scaffoldMessengerState);
      }
    }
  }

  // /////////////////////////////////////////////////////////////////////
  //                         View Methods
  // /////////////////////////////////////////////////////////////////////

  ExerciseFoundationNotesBusReport exerciseFoundationNotesBusReport = ExerciseFoundationNotesBusReport();

  Map<String, List<UserSpecificExerciseBus>> userSpecificMap = {};
  Map<String, ExerciseFoundationNotesBus> notesMap = {};

  StreamBuilder3 getAllExerciseFoundationsWithUserLinks() {
    return StreamBuilder3(
      streams: StreamTuple3(
        reportTaskVar.getPaginated(currentIndex),
        userSpecificExerciseDataReport.getAll(),
        exerciseFoundationNotesBusReport.getAll()
      ),
      builder: (context, snapshots) {
        if (snapshots.snapshot1.connectionState == ConnectionState.waiting || 
            snapshots.snapshot2.connectionState == ConnectionState.waiting || 
            snapshots.snapshot3.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshots.snapshot1.hasError || 
                   snapshots.snapshot2.hasError || 
                   snapshots.snapshot3.hasError) {
          return Text(snapshots.snapshot1.error.toString() + 
                     snapshots.snapshot2.error.toString() + 
                     snapshots.snapshot3.error.toString());
        }

        // Get the paginated foundations and other data
        final newFoundations = snapshots.snapshot1.data!;
        final userSpecificExercises = snapshots.snapshot2.data!;
        final exerciseFoundationNotes = snapshots.snapshot3.data!;
        
        // Clear and rebuild maps for user data
        userSpecificMap.clear();
        notesMap.clear();
        
        for (var exercise in userSpecificExercises) {
          userSpecificMap.putIfAbsent(exercise.foundationId, () => []).add(exercise);
        }
        
        for (var note in exerciseFoundationNotes) {
          notesMap[note.exerciseFoundationId] = note;
        }

        // Update loaded foundations without duplicates
        if (newFoundations.isNotEmpty) {
          for (var foundation in newFoundations) {
            if (!loadedFoundations.any((f) => f.getId() == foundation.getId())) {
              loadedFoundations.add(foundation);
            }
          }
          hasMoreData = newFoundations.length >= pageSize;
        } else {
          hasMoreData = false;
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading && 
                hasMoreData && 
                scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
              loadMoreFoundations();
            }
            return true;
          },
          child: ListView.builder(
            itemCount: loadedFoundations.length + (hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= loadedFoundations.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              ExerciseFoundationBus exerciseFoundation = loadedFoundations[index];
              String id = exerciseFoundation.getId();
              
              exerciseFoundation.userSpecific1RepMaxes = userSpecificMap[id] ?? [];
              exerciseFoundation.exerciseFoundationNotes = notesMap[id];
              
              return ExerciseFoundationListTile(
                exerciseFoundation: exerciseFoundation
              );
            },
          ),
        );
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
    selectedUserSpecificExercise = null;
  }

  void resetUserSpecificExerciseForAdd() {
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
  
  Future<void> loadMoreFoundations() async {
    if (isLoading || !hasMoreData) return;
    
    isLoading = true;
    notifyListeners();

    try {
      final newFoundations = await reportTaskVar.getPaginated(currentIndex).first;
      
      if (newFoundations.isEmpty) {
        hasMoreData = false;
      } else {
        for (var foundation in newFoundations) {
          if (!loadedFoundations.any((f) => f.getId() == foundation.getId())) {
            loadedFoundations.add(foundation);
          }
        }
        currentIndex += newFoundations.length;
        hasMoreData = newFoundations.length >= pageSize;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
