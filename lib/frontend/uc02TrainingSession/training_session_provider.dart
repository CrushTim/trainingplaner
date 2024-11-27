import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/reports/excercise_foundation_bus_report.dart';
import 'package:trainingplaner/business/reports/training_session_bus_report.dart';
import 'package:trainingplaner/business/reports/trainings_cycle_bus_report.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_edit_fields.dart';
import 'package:trainingplaner/frontend/uc03TrainingExercise/training_exercise_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/add_planning_session_dialog.dart';

class TrainingSessionProvider extends TrainingsplanerProvider<
    TrainingSessionBus, TrainingSessionBusReport> {
  late TrainingExerciseProvider exerciseProvider;

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
            reportTaskVar: TrainingSessionBusReport());

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
    TrainingSessionBus? plannedSession, TrainingSessionBus? actualSession) {
    setSelectedBusinessClass(plannedSession, notify: false);
    selectedActualSession = actualSession;
    if(selectedActualSession == null){
      selectedActualSession = getSelectedBusinessClass!.createActualSession();
      isPlannedSessionWithoutActual = true;
    }
  }  /// Sets the selected actual and planned sessions
  void setSelectedSessions() {
    if (plannedToActualSessions.keys.isNotEmpty) {
      setActualAndPlannedSession(plannedToActualSessions.keys.first,
          plannedToActualSessions[plannedToActualSessions.keys.first]);
    } else if (unplannedSessions.isNotEmpty) {
      selectedActualSession = unplannedSessions.first;
      hasNoPlannedSession = true;
    }
  }

  // /////////////////////////////////////////////////////////////////////
  //                         GETTER
  // /////////////////////////////////////////////////////////////////////

  /// Returns a list of unplanned exercises for the selected session
  List<TrainingExerciseBus> getUnplannedExercisesForSession() {
    return selectedActualSession?.trainingSessionExercises
        .where((exercise) => !exerciseProvider.plannedToActualExercises.containsValue(exercise))
        .toList() ?? [];
  }

  // /////////////////////////////////////////////////////////////////////
  //                         RESETTER
  // /////////////////////////////////////////////////////////////////////
  ///method to clear all the maps and lists
  ///is used to clear the maps and lists after a new selection of a session or exercise
  void clearAllMapsAndLists(){
          plannedToActualSessions.clear();
          exerciseProvider.plannedToActualExercises.clear();
          unplannedSessions.clear();
          exerciseProvider.unplannedExercises.clear();
          exerciseProvider.unplannedExercisesForSession.clear();
          selectedActualSession?.trainingSessionExercises.clear();
          getSelectedBusinessClass?.trainingSessionExercises.clear();
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
    clearAllMapsAndLists();
    print(allSessions);  
    mapPlannedAndUnplannedSessions(allSessions);
    mapUnplannedSessionsToPlanned();
    mapPlannedAndUnplannedExercises(allExercises);
    mapUnplannedExercisesToPlanned(allExercises);
    assignExercisesToSessions(allExercises);
    print(exerciseProvider.plannedToActualExercises);
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

  /// Maps all exercises to either planned or unplanned lists
  void mapPlannedAndUnplannedExercises(List<TrainingExerciseBus> allExercises) {
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


  Future<void> deleteExercise(TrainingExerciseBus exercise,
      ScaffoldMessengerState scaffoldMessengerState,
      {bool notify = true}) async {
    String message = "Deleted ${exercise.getName()}";
    try {
      await exercise.delete().onError((error, stackTrace) {
        message = "Error deleting ${exercise.getName()}: ${error.toString()}";
        throw error!;
      });
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

  void initializeSessionMaps(List<TrainingSessionBus> allSessions, List<TrainingExerciseBus> allExercises) {
    
    mapSessionsAndExercisesInCurrentBuilder(allSessions, allExercises);
    getSelectedBusinessClass == null && selectedActualSession == null ? setSelectedSessions() : null;
    
    
    exerciseProvider.unplannedExercisesForSession = exerciseProvider.getUnplannedExercisesForSession(getSelectedBusinessClass!.trainingSessionId);
  }
 


  ///method to get all the existing sessions from the database ordered by date to make them selectable for the workout view
  ///returns a Strembuilder with a list of all session 
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
              TrainingSessionBus? actualSession = plannedToActualSessions[session];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildSessionTile(session, context, isPlanned: true)),
                    if (actualSession != null || !session.isPlanned)
                      Expanded(child: _buildSessionTile(actualSession ?? session, context, isPlanned: false)),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  //TODO: extract to costum widget
  Widget _buildSessionTile(TrainingSessionBus session, BuildContext context, {required bool isPlanned}) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: isPlanned ? Colors.orange[100] : Colors.green[100],
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.trainingSessionName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text(getDateStringForDisplay(session.trainingSessionStartDate)),
                Text(getTimeStringForDisplay(session.trainingSessionStartDate)),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.trainingSessionDescription),
            Text(session.trainingSessionEmphasis.join(', ')),
            Text(session.trainingSessionExercises.map((e) => e.exerciseName).join(', ')),
          ],
        ),
        onTap: () {
          if (isPlanned) {
            setActualAndPlannedSession(session, plannedToActualSessions[session]);
          } else {
            if (unplannedSessions.contains(session)) {
              setActualAndPlannedSession(null, session);
              hasNoPlannedSession = true;
            } else {
              TrainingSessionBus? plannedSession = plannedToActualSessions.keys.firstWhere(
                (s) => s.trainingSessionId == session.plannedSessionId,
                orElse: () => session,
              );
              setActualAndPlannedSession(plannedSession, session);
            }
          }
          Navigator.pop(context);
          notifyListeners();
        },
      ),
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

  void resetAllListsAndBusinessClasses() {
    clearAllMapsAndLists();
    exerciseProvider.resetBusinessClassForAdd();
    exerciseProvider.resetSelectedBusinessClass(); 
    resetSelectedBusinessClass();
    selectedActualSession = null;
    exerciseProvider.resetBusinessClassForAdd();
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
      rethrow;
    }
  }

  void initStateSessionDialog() {
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

  void handleSessionFieldChange(String field, String value) {
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

  Future<void> handleSessionEdit(
    TrainingSessionBus session,
    DateTime date,
    ScaffoldMessengerState scaffoldMessenger,
    BuildContext context,
  ) async {
    try {
      setSelectedBusinessClass(session, notify: false);
      setActualAndPlannedSession(session, plannedToActualSessions[session]);
      initStateSessionDialog();
      
      await showDialog(
        context: context,
        builder: (context) => ChangeNotifierProvider.value(
          value: this,
          child: AddPlanningSessionDialog(
            initialDate: date,
            cycleId: session.trainingCycleId,
          ),
        ),
      );

      resetSessionControllers();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error editing session: ${e.toString()}')),
      );
      rethrow;
    }
  }

  void resetSessionControllers() {
    sessionNameController.clear();
    sessionDescriptionController.clear();
    sessionEmphasisController.clear();
    sessionLengthController.text = "60";
    selectedSessionDate = DateTime.now();
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
}
