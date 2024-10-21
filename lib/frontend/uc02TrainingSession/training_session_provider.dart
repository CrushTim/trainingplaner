import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/reports/training_exercise_bus_report.dart';
import 'package:trainingplaner/business/reports/training_session_bus_report.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_excercise_row.dart';

class TrainingSessionProvider extends TrainingsplanerProvider<
    TrainingSessionBus, TrainingSessionBusReport> {
  TrainingExerciseBusReport trainingExerciseBusReport =
      TrainingExerciseBusReport();

  TrainingSessionBus? selectedActualSession;

  bool hasNoPlannedSession = false;

  bool isPlannedSessionWithoutActual = false;

  Map<TrainingSessionBus, TrainingSessionBus?> plannedToActualSessions = {};
  List<TrainingSessionBus> unplannedSessions = [];
  Map<TrainingExerciseBus, TrainingExerciseBus?> plannedToActualExercises = {};
  List<TrainingExerciseBus> unplannedExercisesForSession = [];
  List<TrainingExerciseBus> unplannedExercises = [];
  TrainingSessionProvider()
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
    return selectedActualSession!.trainingSessionExercises
        .where((exercise) => !plannedToActualExercises.containsValue(exercise))
        .toList();
  }

  // /////////////////////////////////////////////////////////////////////
  //                         RESETTER
  // /////////////////////////////////////////////////////////////////////
  ///method to clear all the maps and lists
  ///is used to clear the maps and lists after a new selection of a session or exercise
  void clearAllMapsAndLists(){
          plannedToActualSessions.clear();
          plannedToActualExercises.clear();
          unplannedSessions.clear();
          unplannedExercises.clear();
          unplannedExercisesForSession.clear();
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
    
    mapPlannedAndUnplannedSessions(allSessions);
    mapUnplannedSessionsToPlanned();
    mapPlannedAndUnplannedExercises(allExercises);
    mapUnplannedExercisesToPlanned(allExercises);
    assignExercisesToSessions(allExercises);
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
        plannedToActualExercises[exercise] = null;
      } else {
        unplannedExercises.add(exercise);
      }
    }
  }

  /// Maps unplanned exercises to their corresponding planned exercises
  void mapUnplannedExercisesToPlanned(List<TrainingExerciseBus> allExercises) {
    for (var exercise in List.from(unplannedExercises)) {
      TrainingExerciseBus? plannedExercise = allExercises.firstWhere(
        (e) => e.trainingExerciseID == exercise.plannedExerciseId,
        orElse: () => exercise,
      );
      if (plannedExercise != exercise) {
        plannedToActualExercises[plannedExercise] = exercise;
        unplannedExercises.remove(exercise);
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
  //                         EXERCISE CRUD
  // /////////////////////////////////////////////////////////////////////

  Future<void> updateExercises(
    List<TrainingExerciseBus> exercises,
    ScaffoldMessengerState scaffoldMessengerState, {
    bool notify = true,
  }) async {
    String message = "Exercises updated";
    try {
      for (var exercise in exercises) {
        await exercise.update().onError((error, stackTrace) {
          message =
              "Error updating ${exercise.exerciseName}: ${error.toString()}";
          throw error!;
        });
      }
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

  Future<String> addExercise(
    TrainingExerciseBus exercise,
    ScaffoldMessengerState scaffoldMessengerState, {
    bool notify = true,
  }) async {
    String exerciseID = "";
    String message = "Added ${exercise.getName()}";
    try {
      exerciseID = await exercise.add();
      return exerciseID;
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
    return exerciseID;
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

  //add a new Exercise to the database
  Future<void> addExerciseToSession(ScaffoldMessengerState scaffoldMessengerState) async {
    TrainingExerciseBus newExercise = TrainingExerciseBus(
      trainingExerciseID: "", // Add a unique ID or generate one
      exerciseName: "mock",
      exerciseDescription: "mock",
      exerciseFoundationID: "mock",
      targetPercentageOf1RM: 100,
      exerciseReps: [], // Add an empty list or initial reps
      exerciseWeights: [], // Add an empty list or initial weights
      isPlanned: false, // Set to false for a new exercise
      plannedExerciseId: "",
      date: DateTime.now(),
    );

    //TODO: make add dialog
    String exerciseID = await addExercise(
            newExercise, scaffoldMessengerState,
        notify: false);
    selectedActualSession!.trainingSessionExcercisesIds.add(exerciseID);
    newExercise.trainingExerciseID = exerciseID;
    selectedActualSession!.trainingSessionExercises.add(newExercise);
    updateBusinessClass(selectedActualSession!, scaffoldMessengerState,
        notify: false);
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

    await updateExercises(exercisesToUpdate, scaffoldMessenger, notify: false);
    // Update the actual session
    if(hasNoPlannedSession){
      await updateBusinessClass(selectedActualSession!, scaffoldMessenger,
            notify: false);
    } else {

      if(plannedToActualSessions.values.contains(selectedActualSession) || isPlannedSessionWithoutActual){
        selectedActualSession!.trainingSessionId = await addBusinessClass(selectedActualSession!, scaffoldMessenger,
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
  StreamBuilder2 getCurrentTrainingSessionStreamBuilder() {
    return StreamBuilder2(
      streams: StreamTuple2(
          reportTaskVar.getAll(), trainingExerciseBusReport.getAll()),
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
          getSelectedBusinessClass == null && selectedActualSession == null ? setSelectedSessions() : null;
          

          unplannedExercisesForSession = getUnplannedExercisesForSession();


          if(selectedActualSession != null || getSelectedBusinessClass != null){
            return _buildTrainingSessionEditFelds(ScaffoldMessenger.of(context));
          } else {
            return const Text("No session to select");
          }
        }
      },
    );
  }

  /// Builds the training session edit fields
  /// Returns a widget that allows the user to edit the training session fields
  /// If no training session is selected, returns a text saying so
  Column _buildTrainingSessionEditFelds(
      ScaffoldMessengerState scaffoldMessenger) {

    final session = selectedActualSession!;
    final TextEditingController workoutNameController =
        TextEditingController(text: session.trainingSessionName);
    final TextEditingController workoutLengthController =
        TextEditingController(text: session.trainingSessionLength.toString());
    final TextEditingController sessionDescriptionController =
        TextEditingController(text: session.trainingSessionDescription);
    final TextEditingController sessionEmphasisController =
        TextEditingController(text: session.trainingSessionEmphasis.join(','));
    DateTime startDate = session.trainingSessionStartDate;

    void updateSessionFromFields() {
      session.trainingSessionName = workoutNameController.text;
      session.trainingSessionLength =
          int.tryParse(workoutLengthController.text) ??
              session.trainingSessionLength;
      session.trainingSessionDescription = sessionDescriptionController.text;
      session.trainingSessionEmphasis = sessionEmphasisController.text.split(',');
      session.trainingSessionStartDate = startDate;
    }

    return Column(
      children: <Widget>[
        TextField(
          controller: workoutNameController,
          decoration: const InputDecoration(labelText: "Workout Name"),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          onChanged: (_) => updateSessionFromFields(),
        ),
        TextField(
          controller: sessionDescriptionController,
          decoration: const InputDecoration(labelText: "Session Description"),
          onChanged: (_) => updateSessionFromFields(),
        ),
        TextField(
          controller: sessionEmphasisController,
          decoration: const InputDecoration(labelText: "Session Emphasis"),
          onChanged: (_) => updateSessionFromFields(),
        ),
        TextField(
          controller: workoutLengthController,
          decoration:
              const InputDecoration(labelText: "Workout Length in minutes"),
          keyboardType: TextInputType.number,
          onChanged: (_) => updateSessionFromFields(),
        ),
        DatePickerSheer(
          initialDateTime: startDate,
          onDateTimeChanged: (DateTime newDateTime) {
            startDate = newDateTime;
            updateSessionFromFields();
          },
          dateController: TextEditingController(text: startDate.toString()),
        ),
        // show all the exercises in the session by showing
        for (TrainingExerciseBus exercise
            in getSelectedBusinessClass?.trainingSessionExercises ?? [])
          TrainingExcerciseRow(
            actualTrainingExercise: plannedToActualExercises[exercise],
            plannedTrainingExercise: exercise,
            onUpdate: (actualExercise) async {
              if (plannedToActualExercises[exercise] == null) {
                String addId = await addExercise(
                    actualExercise, scaffoldMessenger,
                    notify: false);
                selectedActualSession!.trainingSessionExcercisesIds.add(addId);
                actualExercise.trainingExerciseID = addId;
                updateBusinessClass(selectedActualSession!, scaffoldMessenger,
                    notify: false);
              } else {
                updateExercises([actualExercise], scaffoldMessenger,
                    notify: false);
              }
            },
            onDelete: (actualExercise) {
              if (plannedToActualExercises[exercise] != null ||
                  unplannedExercises.contains(exercise)) {
                deleteExercise(actualExercise, scaffoldMessenger,
                    notify: false);
                selectedActualSession!.trainingSessionExcercisesIds
                    .remove(actualExercise.trainingExerciseID);
                selectedActualSession!.trainingSessionExercises
                    .remove(actualExercise);
                updateBusinessClass(selectedActualSession!, scaffoldMessenger,
                    notify: false);
              }
            },
          ),

        //add all the unplanned exercises
        for (TrainingExerciseBus exercise in unplannedExercisesForSession)
          TrainingExcerciseRow(
            actualTrainingExercise: exercise,
            plannedTrainingExercise: null,
            onUpdate: (actualExercise) {
              updateExercises([exercise], scaffoldMessenger, notify: false);
            },
            onDelete: (actualExercise) {
              if (plannedToActualExercises[exercise] != null ||
                  unplannedExercises.contains(exercise)) {
                deleteExercise(actualExercise, scaffoldMessenger,
                    notify: false);
                selectedActualSession!.trainingSessionExcercisesIds
                    .remove(actualExercise.trainingExerciseID);
                selectedActualSession!.trainingSessionExercises
                    .remove(actualExercise);
                updateBusinessClass(selectedActualSession!, scaffoldMessenger,
                    notify: false);
              }
            },
          )
      ],
    );
  }
 


  ///method to get all the existing sessions from the database ordered by date to make them selectable for the workout view
  ///returns a Strembuilder with a list of all session 
  StreamBuilder2 getAllSessionsForWorkoutView() {
    return StreamBuilder2(
      streams: StreamTuple2(reportTaskVar.getAll(), trainingExerciseBusReport.getAll()),
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
}
