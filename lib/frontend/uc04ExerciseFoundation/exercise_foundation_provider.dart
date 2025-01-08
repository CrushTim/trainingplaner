import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_notes.dart';
import 'package:trainingplaner/business/businessClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/business/reports/excercise_foundation_bus_report.dart';
import 'package:trainingplaner/business/reports/exercise_foundation_notes_bus_report.dart';
import 'package:trainingplaner/business/reports/user_specific_exercise_data_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/listTile/exercise_foundation_list_tile.dart';

class ExerciseFoundationProvider extends TrainingsplanerProvider<ExerciseFoundationBus, ExerciseFoundationBusReport> {
  ///represent the currently loaded foundations that are shown in the list
  ///are updated by the user scrolling down to the bottom of the page,
  ///which triggers the loadMoreFoundations method
  List<ExerciseFoundationBus> loadedFoundations = [];
  ///isLoading is used to indicate if the foundations are currently being loaded
  bool isLoading = false;
  ///hasMoreData is used to indicate if there are more foundations to load
  ///if its false, the user can't scroll down to load more foundations and the complete database is loaded
  bool hasMoreData = true;

  //SEARCH RELATED VARIABLES

  ///searchQuery is used to store the current search query
  String searchQuery = '';
  ///searchResults is used to store the search results
  List<ExerciseFoundationBus> searchResults = [];
  ///isSearching is used to indicate if the search is currently active
  bool isSearching = false;


  //USER SPECIFIC EXERCISE RELATED VARIABLES

  ///userSpecificExerciseDataReport is used to get the user specific exercise data
  UserSpecificExerciseDataBusReport userSpecificExerciseDataReport = UserSpecificExerciseDataBusReport();
  ///userSpecificExercise is used to store the user specific exercises
  List<UserSpecificExerciseBus> userSpecificExercise = [];

  //NOTES RELATED VARIABLES

  ///exerciseFoundationNotesBusReport is used to get the exercise foundation notes
  ExerciseFoundationNotesBusReport exerciseFoundationNotesBusReport = ExerciseFoundationNotesBusReport();
  ///userSpecificOneRepMaxMap is used to store the user specific exercises-OneRepMax for each foundation
  ///the key is the foundation id and the value is a list of user specific exercises
  Map<String, List<UserSpecificExerciseBus>> userSpecificOneRepMaxMap = {};
  ///notesMap is used to store the notes for each foundation
  ///the key is the foundation id and the value is the notes for that foundation
  Map<String, ExerciseFoundationNotesBus> notesMap = {};




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

  ///mapToNewInstance is used to create a new instance of the provider
  ///this is used to create a new instance of the provider when the user navigates to a different page
  ///@return: ExerciseFoundationProvider new Instance of the provider with the same state as the current instance
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



  // /////////////////////////////////////////////////////////////////////
  //                         View Methods
  // /////////////////////////////////////////////////////////////////////


  StreamBuilder3 getAllExerciseFoundationsWithUserLinks() {
    return StreamBuilder3(
      streams: StreamTuple3(
        reportTaskVar.getInitialBatch(),
        userSpecificExerciseDataReport.getAll(),
        exerciseFoundationNotesBusReport.getAll()
      ),
      builder: (context, snapshots) {
        if (snapshots.snapshot1.connectionState == ConnectionState.waiting || 
            snapshots.snapshot2.connectionState == ConnectionState.waiting || 
            snapshots.snapshot3.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        
        if (snapshots.snapshot1.hasError || 
            snapshots.snapshot2.hasError || 
            snapshots.snapshot3.hasError) {
          return Text(snapshots.snapshot1.error.toString() + 
                     snapshots.snapshot2.error.toString() + 
                     snapshots.snapshot3.error.toString());
        }

        final initialFoundations = snapshots.snapshot1.data!;
        final userSpecificExercises = snapshots.snapshot2.data!;
        final exerciseFoundationNotes = snapshots.snapshot3.data!;
        
        // Clear and rebuild maps for user data
        userSpecificOneRepMaxMap.clear();
        notesMap.clear();
        
        for (var exercise in userSpecificExercises) {
          userSpecificOneRepMaxMap.putIfAbsent(exercise.foundationId, () => []).add(exercise);
        }
        
        for (var note in exerciseFoundationNotes) {
          notesMap[note.exerciseFoundationId] = note;
        }

        loadedFoundations = initialFoundations;

        return ListView.builder(
          itemCount: loadedFoundations.length + 1, // +1 for the remaining data StreamBuilder
          itemBuilder: (context, index) {
            if (index < loadedFoundations.length) {
              ExerciseFoundationBus exerciseFoundation = loadedFoundations[index];
              String id = exerciseFoundation.getId();
              
              exerciseFoundation.userSpecific1RepMaxes = userSpecificOneRepMaxMap[id] ?? [];
              exerciseFoundation.exerciseFoundationNotes = notesMap[id];
              
              return ExerciseFoundationListTile(
                exerciseFoundation: exerciseFoundation
              );
            } else {
              // Nested StreamBuilder for remaining data
              return StreamBuilder<List<ExerciseFoundationBus>>(
                stream: reportTaskVar.getRemainingData(loadedFoundations.last.exerciseFoundationName),
                builder: (context, remainingSnapshot) {
                  if (remainingSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  if (remainingSnapshot.hasError) {
                    return Text(remainingSnapshot.error.toString());
                  }

                  final remainingFoundations = remainingSnapshot.data ?? [];
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: remainingFoundations.length,
                    itemBuilder: (context, remainingIndex) {
                      ExerciseFoundationBus exerciseFoundation = remainingFoundations[remainingIndex];
                      String id = exerciseFoundation.getId();
                      
                      exerciseFoundation.userSpecific1RepMaxes = userSpecificOneRepMaxMap[id] ?? [];
                      exerciseFoundation.exerciseFoundationNotes = notesMap[id];
                      
                      return ExerciseFoundationListTile(
                        exerciseFoundation: exerciseFoundation
                      );
                    },
                  );
                },
              );
            }
          },
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
      if (loadedFoundations.isEmpty) {
        // Load initial batch
        final initialFoundations = await reportTaskVar.getInitialBatch().first;
        loadedFoundations.addAll(initialFoundations);
      } else {
        // Load next batch using the last item's name as cursor
        final newFoundations = await reportTaskVar.getRemainingData(
          loadedFoundations.last.exerciseFoundationName
        ).first;
        
        if (newFoundations.isEmpty) {
          hasMoreData = false;
        } else {
          for (var foundation in newFoundations) {
            if (!loadedFoundations.any((f) => f.getId() == foundation.getId())) {
              loadedFoundations.add(foundation);
            }
          }
          hasMoreData = newFoundations.length >= 20;
        }
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) async {
    searchQuery = query.toLowerCase();
    isSearching = searchQuery.isNotEmpty;
    
    if (isSearching) {
      // Start loading state
      isLoading = true;
      notifyListeners();
      
      // Get all foundations and filter
      final allFoundations = await reportTaskVar.getAll().first;
      searchResults = allFoundations.where((foundation) {
        return foundation.exerciseFoundationName.toLowerCase().contains(searchQuery);
      }).toList();
      
      // End loading state
      isLoading = false;
    } else {
      searchResults.clear();
    }
    
    notifyListeners();
  }

  void clearSearch() {
    searchQuery = '';
    searchResults.clear();
    isSearching = false;
    notifyListeners();
  }

}
