import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/reports/excercise_foundation_bus_report.dart';
import 'package:trainingplaner/business/reports/training_session_bus_report.dart';
import 'package:trainingplaner/business/reports/trainings_cycle_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_edit_fields.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_tile.dart';
import 'package:trainingplaner/frontend/uc03TrainingExercise/training_exercise_provider.dart';
import 'package:trainingplaner/main.dart';
import 'package:trainingplaner/services/connectivity_service.dart';

class TrainingSessionProvider extends TrainingsplanerProvider<
    TrainingSessionBus, TrainingSessionBusReport> {
  late TrainingExerciseProvider exerciseProvider;
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isOnline = true;

  List<TrainingExerciseBus> tempExercisesToDelete = [];

  TrainingSessionProvider({required this.exerciseProvider})
      : super(
            businessClassForAdd: TrainingSessionBus(
                trainingSessionId: "",
                isPlanned: true,
                trainingSessionName: "",
                trainingSessionDescription: "",
                trainingSessionEmphasis: [],
                trainingSessionExcercisesIds: [],
                trainingSessionLength: 1,
                trainingSessionStartDate: DateTime.now(),
                trainingCycleId: ""),
            reportTaskVar: TrainingSessionBusReport()) {
    _connectivityService.connectionStream.listen((bool isOnline) {
      if (!_isOnline && isOnline) {
        // We're back online, sync temporary exercises
        _syncTemporaryExercises();
      }
      _isOnline = isOnline;
    });
  }

  TrainingSessionBus? selectedActualSession;
  bool hasNoPlannedSession = false;
  bool isPlannedSessionWithoutActual = false;
  Map<TrainingSessionBus, TrainingSessionBus?> plannedToActualSessions = {};
  List<TrainingSessionBus> unplannedSessions = [];
  List<TrainingCycleBus> allCycles = [];
  DateTime selectedSessionDate = DateTime.now();

  final TextEditingController sessionNameController = TextEditingController();
  final TextEditingController sessionDescriptionController = TextEditingController();
  final TextEditingController sessionEmphasisController = TextEditingController();
  final TextEditingController sessionLengthController = TextEditingController();
  List<TrainingExerciseBus> tempExercises = [];
  void updateSessionDate(DateTime date) {
    selectedSessionDate = date;
    final target = getSelectedBusinessClass ?? businessClassForAdd;
    target.trainingSessionStartDate = date;
    notifyListeners();
  }


  // /////////////////////////////////////////////////////////////////////
  //                         SETTER
  // /////////////////////////////////////////////////////////////////////
  void setActualAndPlannedSession(
    TrainingSessionBus? plannedSession, 
    TrainingSessionBus? actualSession
  ) {
    setSelectedBusinessClass(plannedSession, notify: false);
    
    // First check if we have an actual session passed in
    if (actualSession != null) {
      selectedActualSession = actualSession;
      selectedSessionDate = actualSession.trainingSessionStartDate;
      isPlannedSessionWithoutActual = false;
    } 
    // Then check if there's one in the map
    else if (plannedSession != null && plannedToActualSessions[plannedSession] != null) {
      selectedActualSession = plannedToActualSessions[plannedSession];
      selectedSessionDate = selectedActualSession!.trainingSessionStartDate;
      isPlannedSessionWithoutActual = false;
    }
    // Only create new actual session if we truly don't have one
    else if (plannedSession != null) {
      selectedActualSession = plannedSession.createActualSession();
      selectedSessionDate = plannedSession.trainingSessionStartDate;
      isPlannedSessionWithoutActual = true;
    }
  }  /// Sets the selected actual and planned sessions
  void setSelectedSession() {
    if (plannedToActualSessions.keys.isNotEmpty) {
      setActualAndPlannedSession(plannedToActualSessions.keys.first,
          plannedToActualSessions[plannedToActualSessions.keys.first]);
    } else if (unplannedSessions.isNotEmpty) {
      selectedActualSession = unplannedSessions.first;
      hasNoPlannedSession = true;
    }
  }



  // /////////////////////////////////////////////////////////////////////
  //                         RESETTER
  // /////////////////////////////////////////////////////////////////////
  ///method to clear all the maps and lists
  ///is used to clear the maps and lists after a new selection of a session or exercise
  void resetAllMapsAndLists(){
          plannedToActualSessions.clear();
          exerciseProvider.plannedToActualExercises.clear();
          unplannedSessions.clear();
          exerciseProvider.unplannedExercises.clear();
          exerciseProvider.unplannedExercisesForSession.clear();
          selectedActualSession?.trainingSessionExercises.clear();
          getSelectedBusinessClass?.trainingSessionExercises.clear();
  }

  ///method to reset the session controllers
  ///is used to reset the session controllers after a new selection of a session or exercise
  void resetSessionControllers() {
    sessionNameController.clear();
    sessionDescriptionController.clear();
    sessionEmphasisController.clear();
    sessionLengthController.text = "60";
    selectedSessionDate = DateTime.now();
  }

  void resetAllListsAndBusinessClasses() {
    resetAllMapsAndLists();
    exerciseProvider.resetBusinessClassForAdd();
    exerciseProvider.resetSelectedBusinessClass(); 
    resetSelectedBusinessClass();
    selectedActualSession = null;
    exerciseProvider.resetBusinessClassForAdd();
  }

  // /////////////////////////////////////////////////////////////////////
  //                         INITIALIZER
  // /////////////////////////////////////////////////////////////////////
  
  ///method to initialize the session maps
  ///
   void initializeSessionMaps(List<TrainingSessionBus> allSessions, List<TrainingExerciseBus> allExercises) {
    
    mapSessionsAndExercisesInCurrentBuilder(allSessions, allExercises);
    getSelectedBusinessClass == null && selectedActualSession == null ? setSelectedSession() : null;
    
  if(selectedActualSession != null){
    exerciseProvider.unplannedExercisesForSession = exerciseProvider.getUnplannedExercisesForSession(selectedActualSession!);
  }    
  }


  // /////////////////////////////////////////////////////////////////////
  //                         MAPPER
  // /////////////////////////////////////////////////////////////////////

  ///map the ids of the exercises to an TrainingSessionBus trainingSessionExercisesIDs list
  ///is used to get the ids of the exercises so they can be saved in the database
  void mapExerciseIdsToSession(
      TrainingSessionBus session, List<TrainingExerciseBus> exercises) {
    for (TrainingExerciseBus exercise in exercises) {
      session.trainingSessionExcercisesIds.add(exercise.trainingExerciseID);
    }
  }


  /// Maps all sessions and exercises to either planned or unplanned lists
  /// is used to map the sessions and exercises to the lists after a new selection of a session or exercise
  void mapSessionsAndExercisesInCurrentBuilder(List<TrainingSessionBus> allSessions, List<TrainingExerciseBus> allExercises) {
    // Store temporary exercises before reset
    resetAllMapsAndLists();
    
    // Restore temporary exercises to session
    if (selectedActualSession != null && tempExercises.isNotEmpty) {
      selectedActualSession!.trainingSessionExercises.addAll(tempExercises);
      selectedActualSession!.trainingSessionExcercisesIds
          .addAll(tempExercises.map((e) => e.trainingExerciseID));
    }
    
    //initialize the session maps 
    mapSessionsToSessionMap(allSessions);
    //initialize the exercise maps 
    mapExercisesToExerciseMap(allExercises);
    //assign the exercises to the sessions
    assignExercisesToSessions(allExercises);
    
    //if there is a selected actual session, get the unplanned exercises for the session
    if(selectedActualSession != null){
    }
    if(tempExercises.isNotEmpty){
      exerciseProvider.unplannedExercisesForSession.addAll(tempExercises);
    }
  }

  void mapSessionsToSessionMap(List<TrainingSessionBus> allSessions){
    //map all Sessions to the planned keys of the map or keep the actual sessions in the unplanned list
    mapPlannedAndUnplannedSessions(allSessions);

    //now go through all the actual sessions in the unplanned list and map them to the planned sessions
    //if there is no planned session for an actual session, keep the actual session in the unplanned list
    mapUnplannedSessionsToPlanned();
  }

  /// Maps all sessions to either planned or unplanned lists
  void mapPlannedAndUnplannedSessions(List<TrainingSessionBus> allSessions) {
    for (var session in allSessions) {
      if (session.isPlanned) {
        plannedToActualSessions[session] = null;
      } else {
        unplannedSessions.add(session);
      }
    }
  }

  /// Maps unplanned sessions to their corresponding planned sessions
  void mapUnplannedSessionsToPlanned() {
    for (var session in List.from(unplannedSessions)) {
      TrainingSessionBus? plannedSession = plannedToActualSessions.keys.firstWhere(
        (s) => s.trainingSessionId == session.plannedSessionId,
        orElse: () => session,
      );
      if (plannedSession != session) {
        plannedToActualSessions[plannedSession] = session;
        unplannedSessions.remove(session);
      }
    }
  }

  void mapExercisesToExerciseMap(List<TrainingExerciseBus> allExercises){
    //map all exercises to the planned keys of the map or keep the unplanned exercises in the unplanned list
    mapPlannedExercises(allExercises);

    //now go through all the unplanned exercises in the unplanned list and map them to the planned exercises
    //if there is no planned exercise for an unplanned exercise, keep the unplanned exercise in the unplanned list
    mapUnplannedExercisesToPlanned(allExercises);
  }

  /// Maps all exercises to either planned or unplanned lists
  void mapPlannedExercises(List<TrainingExerciseBus> allExercises) {
    for (var exercise in allExercises) {
      if (exercise.isPlanned) {
        exerciseProvider.plannedToActualExercises[exercise] = null;
      } else {
        exerciseProvider.unplannedExercises.add(exercise);
      }
    }
  }

  /// Maps unplanned exercises to their corresponding planned exercises
  void mapUnplannedExercisesToPlanned(List<TrainingExerciseBus> allExercises) {
    for (var exercise in List.from(exerciseProvider.unplannedExercises)) {
      TrainingExerciseBus? plannedExercise = allExercises.firstWhere(
        (e) => e.trainingExerciseID == exercise.plannedExerciseId,
        orElse: () => exercise,
      );
      if (plannedExercise != exercise) {
        exerciseProvider.plannedToActualExercises[plannedExercise] = exercise;
        exerciseProvider.unplannedExercises.remove(exercise);
      }
    }
  }

  /// Assigns exercises to their corresponding sessions
  void assignExercisesToSessions(List<TrainingExerciseBus> allExercises) {
    for (TrainingExerciseBus exercise in allExercises) {
      if (selectedActualSession != null &&
          selectedActualSession!.trainingSessionExcercisesIds
              .contains(exercise.trainingExerciseID)) {
        selectedActualSession!.trainingSessionExercises.add(exercise);
      }
      if (getSelectedBusinessClass != null &&
          getSelectedBusinessClass!.trainingSessionExcercisesIds
              .contains(exercise.trainingExerciseID)) {
        getSelectedBusinessClass!.trainingSessionExercises.add(exercise);
      }
    }
  }




  // /////////////////////////////////////////////////////////////////////
  //                         SESSION CRUD
  // /////////////////////////////////////////////////////////////////////

   /// Updates the session and its exercises
  ///
  /// If the session is planned, it checks if there is an actual session for it.
  /// If not, it creates one. Then it updates or creates the exercises in the session.
  /// Finally, it updates the session in the database.

  Future<void> updateSessionInDatabase(ScaffoldMessengerState scaffoldMessenger) async {
    if (selectedActualSession == null && getSelectedBusinessClass == null) {
      scaffoldMessenger
          .showSnackBar(const SnackBar(content: Text('No session selected')));
      return;
    }
    // Update exercises for both planned and actual sessions
    List<TrainingExerciseBus> exercisesToUpdate = [
      ...(getSelectedBusinessClass?.trainingSessionExercises ?? []),
      ...(selectedActualSession?.trainingSessionExercises ?? []),
    ];

        await exerciseProvider.updateExercises(exercisesToUpdate, scaffoldMessenger, notify: false);
    // Update the actual session
    if(hasNoPlannedSession){
      await updateBusinessClass(selectedActualSession!, scaffoldMessenger,
            notify: false);
    } else {

      if(plannedToActualSessions.values.contains(selectedActualSession) || isPlannedSessionWithoutActual){
        await addBusinessClass(selectedActualSession!, scaffoldMessenger,
            notify: false);
      } else {
        await updateBusinessClass(selectedActualSession!, scaffoldMessenger,
            notify: false);
      }
      
    }
    // Update the planned session
    if(getSelectedBusinessClass != null){
    await updateSelectedBusinessClass(scaffoldMessenger,
        notify: true);
    }


    isPlannedSessionWithoutActual = false;
    scaffoldMessenger
        .showSnackBar(const SnackBar(content: Text('Session and exercises updated')));
  }

  
  // /////////////////////////////////////////////////////////////////////
  //                         STREAMBUILDER
  // /////////////////////////////////////////////////////////////////////

  ///method to get the current training session stream builder
  ///if the view is initialized with no selected actual or planned session, the session and exercises are set by the first planned session in the plannedToActualSessions map
  ///if there is a selected actual or planned session, the session and exercises are set by the selected session
  ///the builder returns the training session edit fields or a text saying no session selected
  StreamBuilder3 getCurrentTrainingSessionStreamBuilder() {
    return StreamBuilder3(
      streams: StreamTuple3(
          reportTaskVar.getAll(), exerciseProvider.reportTaskVar.getAll(), TrainingCycleBusReport().getAll()),
      builder: (context, snapshots) {
        if (snapshots.snapshot1.connectionState == ConnectionState.waiting ||
            snapshots.snapshot2.connectionState == ConnectionState.waiting ||
            snapshots.snapshot3.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshots.snapshot1.hasError ||
            snapshots.snapshot2.hasError ||
            snapshots.snapshot3.hasError) {
          if (snapshots.snapshot1.hasError) {
            return Text(snapshots.snapshot1.error.toString());
          } else if (snapshots.snapshot2.hasError) {
            return Text(snapshots.snapshot2.error.toString());
          } else {
            return Text(snapshots.snapshot3.error.toString());
          }
        } else {
          List<TrainingSessionBus> allSessions = snapshots.snapshot1.data!;
          List<TrainingExerciseBus> allExercises = snapshots.snapshot2.data!;
          allCycles = snapshots.snapshot3.data!;

          initializeSessionMaps(allSessions, allExercises);


          if(selectedActualSession != null || getSelectedBusinessClass != null){
            return const TrainingSessionEditFields();
          } else {
            return const Text("No session to select");
          }
        }
      },
    );
  }

 
 


  ///method to get all the existing sessions from the database ordered by date to make them selectable for the workout view
  ///returns a Strembuilder with a list of all session 
  ///maps all the planned and unplanned next to each other in the list 
  StreamBuilder2 getAllSessionsForWorkoutView() {
    return StreamBuilder2(
      streams: StreamTuple2(reportTaskVar.getAll(), exerciseProvider.reportTaskVar.getAll()),
      builder: (context, snapshots) {
        if (snapshots.snapshot1.connectionState == ConnectionState.waiting ||
            snapshots.snapshot2.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshots.snapshot1.hasError ||
            snapshots.snapshot2.hasError) {
          if (snapshots.snapshot1.hasError) {
            return Text(snapshots.snapshot1.error.toString());
          } else {
            return Text(snapshots.snapshot2.error.toString());
          }
        } else {
          List<TrainingSessionBus> allSessions = snapshots.snapshot1.data!;
          List<TrainingExerciseBus> allExercises = snapshots.snapshot2.data!;

          mapSessionsAndExercisesInCurrentBuilder(allSessions, allExercises);

          // Combine planned sessions and unplanned sessions
          List<TrainingSessionBus> sortedSessions = [
            ...plannedToActualSessions.keys,
            ...unplannedSessions,
          ];

          // Sort all sessions by date
          sortedSessions.sort((a, b) => b.trainingSessionStartDate.compareTo(a.trainingSessionStartDate));

          return ListView.builder(
            itemCount: sortedSessions.length,
            itemBuilder: (context, index) {
              TrainingSessionBus session = sortedSessions[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (session.isPlanned) 
                      // For planned sessions, show both planned and actual in a row
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: SessionTile(
                                session: session,
                                isPlanned: true,
                                onTap: () {
                                  setActualAndPlannedSession(session, plannedToActualSessions[session]);
                                  Navigator.pop(context);
                                  notifyListeners();
                                },
                              ),
                            ),
                            if (plannedToActualSessions[session] != null)
                              Expanded(
                                child: SessionTile(
                                  session: plannedToActualSessions[session]!,
                                  isPlanned: false,
                                  onTap: () {
                                    setActualAndPlannedSession(session, plannedToActualSessions[session]);
                                    Navigator.pop(context);
                                    notifyListeners();
                                  },
                                ),
                              ),
                          ],
                        ),
                      )
                    else
                      // For unplanned sessions, show just the actual session
                      Expanded(
                        child: SessionTile(
                          session: session,
                          isPlanned: false,
                          onTap: () {
                            setActualAndPlannedSession(null, session);
                            hasNoPlannedSession = true;
                            Navigator.pop(context);
                            notifyListeners();
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }




  

  ////////////////////////////////STUFF FOR FOUNDATION ID ///////////////////////////////////
  
  ExerciseFoundationBusReport exerciseFoundationReport = ExerciseFoundationBusReport();

  StreamBuilder getFoundationAutoComplete() {
    return StreamBuilder(
      stream: exerciseFoundationReport.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          exerciseProvider.availableFoundations = snapshot.data!;
          return Autocomplete<ExerciseFoundationBus>(
            
            displayStringForOption: (ExerciseFoundationBus option) => option.exerciseFoundationName,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<ExerciseFoundationBus>.empty();
              }
              return exerciseProvider.availableFoundations.where((foundation) {
                return foundation.exerciseFoundationName
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (ExerciseFoundationBus selection) {
              if (exerciseProvider.getSelectedBusinessClass != null) {
                exerciseProvider.getSelectedBusinessClass!.exerciseFoundationID = selection.getId();
              } else {
                exerciseProvider.businessClassForAdd.exerciseFoundationID = selection.getId();
              }
            },
          );
        }
      },
    );
  }

  

  Future<void> copySessionToDate(
    TrainingSessionBus plannedSession,
    DateTime newDate,
    ScaffoldMessengerState scaffoldMessengerState,
  ) async {
    final newSession = TrainingSessionBus(
      trainingSessionId: "",
      trainingSessionName: plannedSession.trainingSessionName,
      trainingSessionDescription: plannedSession.trainingSessionDescription,
      trainingSessionStartDate: DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        plannedSession.trainingSessionStartDate.hour,
        plannedSession.trainingSessionStartDate.minute,
      ),
      trainingSessionLength: plannedSession.trainingSessionLength,
      trainingSessionExcercisesIds: List.from(plannedSession.trainingSessionExcercisesIds),
      trainingSessionEmphasis: List.from(plannedSession.trainingSessionEmphasis),
      isPlanned: true,
      trainingCycleId: plannedSession.trainingCycleId,
    );

    try {
      await addBusinessClass(newSession, scaffoldMessengerState, notify: false);
    } catch (e) {
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text('Error copying session: ${e.toString()}')),
      );
    }
  }

  void initControllersForPlanningView() {
    final target = getSelectedBusinessClass;
    if (target != null) {
      sessionNameController.text = target.trainingSessionName;
      sessionDescriptionController.text = target.trainingSessionDescription;
      sessionEmphasisController.text = target.trainingSessionEmphasis.join(', ');
      sessionLengthController.text = target.trainingSessionLength.toString();
      selectedSessionDate = target.trainingSessionStartDate;
    } else {
      sessionNameController.clear();
      sessionDescriptionController.clear();
      sessionEmphasisController.clear();
      sessionLengthController.text = "60";
      selectedSessionDate = DateTime.now();
    }
  }

  void handleSessionFieldChangeForPlanned(String field, String value) {
    final target = getSelectedBusinessClass ?? businessClassForAdd;
    switch (field) {
      case 'name':
        target.trainingSessionName = value;
        break;
      case 'description':
        target.trainingSessionDescription = value;
        break;
      case 'emphasis':
        target.trainingSessionEmphasis = value.split(',').map((e) => e.trim()).toList();
        break;
      case 'length':
        target.trainingSessionLength = int.tryParse(value) ?? 60;
        break;
    }
  }

  void handleSessionFieldChangeForActual(String field, String value) {
    final target = selectedActualSession ?? businessClassForAdd;
    switch (field) {
      case 'name':
        target.trainingSessionName = value;
        break;
      case 'description':
        target.trainingSessionDescription = value;
        break;
      case 'emphasis':
        target.trainingSessionEmphasis = value.split(',').map((e) => e.trim()).toList();
        break;
      case 'length':
        target.trainingSessionLength = int.tryParse(value) ?? 60;
        break;
      case 'cycle':
        target.trainingCycleId = value;
        break;
      case 'date':
        target.trainingSessionStartDate = DateTime.parse(value);
        break;
    }
  } 

  Future<void> saveSession(BuildContext context) async {
    if (getSelectedBusinessClass != null) {
      await updateSelectedBusinessClass(
        ScaffoldMessenger.of(context),
      );
    } else {
      await addBusinessClass(
        businessClassForAdd,
        ScaffoldMessenger.of(context),
      );
    }
    
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> addTemporaryExercise(TrainingExerciseBus exercise) async {
    if (_connectivityService.isConnected) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(const SnackBar(content: Text('Online')));
      // Online - add directly to database
      final permanentId = await exerciseProvider.addBusinessClass(
        exercise,
        ScaffoldMessenger.of(navigatorKey.currentContext!),
      );
      selectedActualSession?.trainingSessionExcercisesIds.add(permanentId);
      exerciseProvider.unplannedExercisesForSession.add(exercise);

      updateBusinessClass(selectedActualSession!, ScaffoldMessenger.of(navigatorKey.currentContext!));
    } else {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(const SnackBar(content: Text('Offline - only The Last Session with its exercises will be saved')));
      // Offline - add to temporary storage
      TrainingExerciseBus exerciseCopy = TrainingExerciseBus(
        trainingExerciseID: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        exerciseName: exercise.exerciseName,
        exerciseDescription: exercise.exerciseDescription,
        exerciseFoundationID: exercise.exerciseFoundationID,
        exerciseReps: List.from(exercise.exerciseReps),
        exerciseWeights: List.from(exercise.exerciseWeights),
        date: exercise.date,
        isPlanned: false,
        targetPercentageOf1RM: exercise.targetPercentageOf1RM,
      );

      selectedActualSession?.trainingSessionExcercisesIds.add(exerciseCopy.trainingExerciseID);
      selectedActualSession?.trainingSessionExercises.add(exerciseCopy);
      exerciseProvider.unplannedExercisesForSession.add(exerciseCopy);
      tempExercises.add(exerciseCopy);
      
    }
    
      notifyListeners();
  }

  Future<void> _syncTemporaryExercises() async {
    if ((tempExercises.isEmpty && tempExercisesToDelete.isEmpty) || selectedActualSession == null ) return;

    final scaffoldMessenger = ScaffoldMessenger.of(navigatorKey.currentContext!);
    
    try {
      for (var exercise in List.from(tempExercises)) {
        //Check if the exercise is already in the database
        if (exerciseProvider.plannedToActualExercises.values.contains(exercise) || exerciseProvider.unplannedExercises.contains(exercise)) {
          exerciseProvider.updateBusinessClass(exercise, scaffoldMessenger, notify: false);
          tempExercises.remove(exercise);
        } else {
          // Add the exercise permanently
          final permanentId = await exerciseProvider.addBusinessClass(
          exercise,
          scaffoldMessenger,
          notify: false,
        );
        
        // Update the session with the new permanent ID
        final index = selectedActualSession!.trainingSessionExcercisesIds
            .indexOf(exercise.trainingExerciseID);
        if (index != -1) {
          selectedActualSession!.trainingSessionExcercisesIds[index] = permanentId;
          exercise.trainingExerciseID = permanentId;
        }
        
          tempExercises.remove(exercise);
        }
      
      
      }

      for(var exercise in tempExercisesToDelete){
        exerciseProvider.deleteBusinessClass(exercise, scaffoldMessenger, notify: false);
        selectedActualSession!.trainingSessionExcercisesIds.remove(exercise.trainingExerciseID);
        selectedActualSession!.trainingSessionExercises.remove(exercise);
      }
      tempExercisesToDelete.clear();
      
      // Create a new list with only the non-temporary IDs
      selectedActualSession!.trainingSessionExcercisesIds = 
          selectedActualSession!.trainingSessionExcercisesIds
              .where((id) => !id.startsWith('temp_'))
              .toList();
      // Update the session with all changes
      await updateBusinessClass(selectedActualSession!, scaffoldMessenger);
      notifyListeners();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error syncing offline changes: ${e.toString()}')),
      );
    }
  }
}
