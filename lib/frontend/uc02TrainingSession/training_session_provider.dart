import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/reports/training_exercise_bus_report.dart';
import 'package:trainingplaner/business/reports/training_session_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_excercise_row.dart';

class TrainingSessionProvider extends TrainingsplanerProvider<
    TrainingSessionBus, TrainingSessionBusReport> {
  TrainingExerciseBusReport trainingExerciseBusReport =
      TrainingExerciseBusReport();

  TrainingSessionBus? selectedActualSession;

  bool hasNoPlannedSession = false;

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

  ///map the ids of the exercises to an TrainingSessionBus trainingSessionExercisesIDs list
  ///is used to get the ids of the exercises so they can be saved in the database
  void mapExerciseIdsToSession(
      TrainingSessionBus session, List<TrainingExerciseBus> exercises) {
    for (TrainingExerciseBus exercise in exercises) {
      session.trainingSessionExcercisesIds.add(exercise.trainingExerciseID);
    }
  }

  Widget getCurrentTrainingSessionStreamBuilder() {
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
          //get all the sessions of the user
          List<TrainingSessionBus> allSessions = snapshots.snapshot1.data!;
          List<TrainingExerciseBus> allExercises = snapshots.snapshot2.data!;

          // Clear and rebuild the maps
          plannedToActualSessions.clear();
          plannedToActualExercises.clear();
          unplannedSessions.clear();
          unplannedExercises.clear();
          unplannedExercisesForSession.clear();
          selectedActualSession?.trainingSessionExercises.clear();
          getSelectedBusinessClass?.trainingSessionExercises.clear();
          

          // Map all sessions (planned and actual)
          for (var session in allSessions) {
            if (session.isPlanned) {
              plannedToActualSessions[session] = null;
            } else {
              unplannedSessions.add(session);
            }
          }

          //go through all the unplanned sessions and either map them to their planned session or leave them to the unplanned list
          for (var session in unplannedSessions) {
            TrainingSessionBus? plannedSession =
                plannedToActualSessions.keys.firstWhere(
              (s) => s.trainingSessionId == session.plannedSessionId,
              orElse: () => session,
            );
            if (plannedSession != session) {
              plannedToActualSessions[plannedSession] = session;
              unplannedSessions.remove(session);
            }
          }
          //now set the unplanned and planned exercise for the view
          if (plannedToActualSessions.keys.isNotEmpty) {
            setActualAndPlannedSession(plannedToActualSessions.keys.first,
                plannedToActualSessions[plannedToActualSessions.keys.first]);
          } else if (unplannedSessions.isNotEmpty){
              selectedActualSession = unplannedSessions.first;
              hasNoPlannedSession = true;
            }
          


          //now fill the exercises map with the planned and actual exercises
          for (var exercise in allExercises) {
            if (exercise.isPlanned) {
              plannedToActualExercises[exercise] = null;
            } else {
              unplannedExercises.add(exercise);
            }
          }

          //go through all the unplanned exercises and either map them to their planned exercise or leave them to the unplanned list
          for (var exercise in unplannedExercises) {
            TrainingExerciseBus? plannedExercise = allExercises.firstWhere(
              (e) => e.trainingExerciseID == exercise.plannedExerciseId,
              orElse: () => exercise,
            );
            if (plannedExercise != exercise) {
              plannedToActualExercises[plannedExercise] = exercise;
              unplannedExercises.remove(exercise);
            }
          }

          // Assign exercises to sessions
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

          
          
  unplannedExercisesForSession = selectedActualSession!
      .trainingSessionExercises
      .where((exercise) =>
          !plannedToActualExercises.containsValue(exercise))
      .toList();
      if(selectedActualSession != null || getSelectedBusinessClass != null){
        return buildTrainingSessionEditFelds(ScaffoldMessenger.of(context));
      }else{
        return const Text("No session to select");
      }

        }
      },
    );
  }

  void setActualAndPlannedSession(
      TrainingSessionBus? plannedSession, TrainingSessionBus? actualSession) {
    setSelectedBusinessClass(plannedSession, notify: false);
    selectedActualSession = actualSession;
    selectedActualSession ??= getSelectedBusinessClass!.createActualSession();
  }

  /// Builds the training session edit fields
  ///
  /// Returns a widget that allows the user to edit the training session fields
  ///
  /// If no training session is selected, returns a text saying so
  ///
  Widget buildTrainingSessionEditFelds(
      ScaffoldMessengerState scaffoldMessenger) {

    final session = selectedActualSession!;
    print("id ${session}");
    final TextEditingController workoutNameController =
        TextEditingController(text: session.trainingSessionName);
    final TextEditingController workoutLengthController =
        TextEditingController(text: session.trainingSessionLength.toString());
    final TextEditingController sessionDescriptionController =
        TextEditingController(text: session.trainingSessionDescription);
    final TextEditingController sessionEmphasisController =
        TextEditingController(text: session.trainingSessionEmphasis.toString());
    DateTime startDate = session.trainingSessionStartDate;

    void updateSessionFromFields() {
      session.trainingSessionName = workoutNameController.text;
      session.trainingSessionLength =
          int.tryParse(workoutLengthController.text) ??
              session.trainingSessionLength;
      session.trainingSessionDescription = sessionDescriptionController.text;
      session.trainingSessionEmphasis = [sessionEmphasisController.text];
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

  /// Updates the session and its exercises
  ///
  /// If the session is planned, it checks if there is an actual session for it.
  /// If not, it creates one. Then it updates or creates the exercises in the session.
  /// Finally, it updates the session in the database.

  Future<void> updateSessionInDatabase(ScaffoldMessengerState scaffoldMessenger) async {
    if (selectedActualSession == null && getSelectedBusinessClass == null) {
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text('No session selected')));
      return;
    }
    print("selected actual session ${selectedActualSession}");
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
       plannedToActualSessions[getSelectedBusinessClass!] == null
        ? await addBusinessClass(selectedActualSession!, scaffoldMessenger,
            notify: false)
        : await updateBusinessClass(selectedActualSession!, scaffoldMessenger,
            notify: false);

    }
    // Update the planned session
    if(getSelectedBusinessClass != null){
    await updateSelectedBusinessClass(scaffoldMessenger,
        notify: true);
    }



    scaffoldMessenger
        .showSnackBar(const SnackBar(content: Text('Session and exercises updated')));
  }

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
  Future<void> addExerciseToSession(BuildContext context) async {
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
        newExercise, ScaffoldMessenger.of(context),
        notify: false);
    print(exerciseID);
    selectedActualSession!.trainingSessionExcercisesIds.add(exerciseID);
    newExercise.trainingExerciseID = exerciseID;
    selectedActualSession!.trainingSessionExercises.add(newExercise);
    updateBusinessClass(selectedActualSession!, ScaffoldMessenger.of(context),
        notify: false);
  }
}
