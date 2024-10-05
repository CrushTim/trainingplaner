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

  Map<TrainingSessionBus, TrainingSessionBus?> plannedToActualSessions = {};
  List<TrainingSessionBus> unplannedSessions = [];
  Map<TrainingExerciseBus, TrainingExerciseBus?> plannedToActualExercises = {};
  List<TrainingExerciseBus> unplannedExercises = [];

  bool isNewActualSession = false;

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
          List<TrainingSessionBus> allSessions = snapshots.snapshot1.data!;
          List<TrainingExerciseBus> allExercises = snapshots.snapshot2.data!;

          // Clear and rebuild the maps
          plannedToActualSessions.clear();
          plannedToActualExercises.clear();
          unplannedSessions.clear();
          unplannedExercises.clear();

          // Map all sessions (planned and actual)
          for (var session in allSessions) {
            if (session.isPlanned) {
              plannedToActualSessions[session] = null;
            } else {
              var plannedSession = allSessions.firstWhere(
                (s) => s.trainingSessionId == session.plannedSessionId,
                orElse: () => session,
              );
              if (plannedSession == session) {
                unplannedSessions.add(session);
              } else {
                plannedToActualSessions[plannedSession] = session;
              }
            }
          }

          // Map all exercises (planned and actual)
          for (var exercise in allExercises) {
            if (exercise.isPlanned) {
              plannedToActualExercises[exercise] = null;
            } else {
              var plannedExercise = allExercises.firstWhere(
                (e) => e.trainingExerciseID == exercise.plannedExerciseId,
                orElse: () => exercise,
              );
              if (plannedExercise == exercise) {
                unplannedExercises.add(exercise);
              } else {
                plannedToActualExercises[plannedExercise] = exercise;
              }
            }
          }

          // Assign exercises to sessions
          for (var session in allSessions) {
            session.trainingSessionExercises = allExercises
                .where((exercise) => session.trainingSessionExcercisesIds
                    .contains(exercise.trainingExerciseID))
                .toList();
          }

          /// set all selected planned and actual sessions and exercises
          if (allSessions.isNotEmpty) {
            if (plannedToActualSessions.keys.isNotEmpty) {
              setSelectedBusinessClass(plannedToActualSessions.keys.first,
                  notify: false);
              selectedActualSession =
                  plannedToActualSessions[getSelectedBusinessClass!];
              isNewActualSession = selectedActualSession == null;
              selectedActualSession ??=
                  getSelectedBusinessClass!.createActualSession();
            }
            return buildTrainingSessionEditFelds(ScaffoldMessenger.of(context));
          } else {
            return const Text("No training sessions available");
          }
        }
      },
    );
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
    final TextEditingController workoutNameController =
        TextEditingController(text: session.trainingSessionName);
    final TextEditingController workoutLengthController =
        TextEditingController(text: session.trainingSessionLength.toString());
    final TextEditingController sessionDescriptionController =
        TextEditingController(text: session.trainingSessionDescription);
    final TextEditingController sessionEmphasisController =
        TextEditingController(text: session.trainingSessionEmphasis.toString());
    DateTime startDate = session.trainingSessionStartDate;

    void updateSession() {
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
          onChanged: (_) => updateSession(),
        ),
        TextField(
          controller: sessionDescriptionController,
          decoration: const InputDecoration(labelText: "Session Description"),
          onChanged: (_) => updateSession(),
        ),
        TextField(
          controller: sessionEmphasisController,
          decoration: const InputDecoration(labelText: "Session Emphasis"),
          onChanged: (_) => updateSession(),
        ),
        TextField(
          controller: workoutLengthController,
          decoration:
              const InputDecoration(labelText: "Workout Length in minutes"),
          keyboardType: TextInputType.number,
          onChanged: (_) => updateSession(),
        ),
        DatePickerSheer(
          initialDateTime: startDate,
          onDateTimeChanged: (DateTime newDateTime) {
            startDate = newDateTime;
            updateSession();
          },
          dateController: TextEditingController(text: startDate.toString()),
        ),
        // show all the exercises in the session by showing
        for (TrainingExerciseBus exercise in plannedToActualExercises.keys)
          TrainingExcerciseRow(
            actualTrainingExercise: plannedToActualExercises[exercise],
            plannedTrainingExercise: exercise,
            onUpdate: (isNew) {
              if (isNew) {
                addExercise(exercise, scaffoldMessenger);
              } else {
                updateExercises([exercise], scaffoldMessenger);
              }
            },
          ),

        //add all the unplanned exercises
        for (TrainingExerciseBus exercise in unplannedExercises)
          TrainingExcerciseRow(
            actualTrainingExercise: exercise,
            plannedTrainingExercise: null,
            onUpdate: (isNew) {
              if (isNew) {
                addExercise(exercise, scaffoldMessenger, notify: false);
              } else {
                updateExercises([exercise], scaffoldMessenger, notify: false);
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

  void updateSessionInDatabase(ScaffoldMessengerState scaffoldMessenger) {
    if (selectedActualSession == null || getSelectedBusinessClass == null) {
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text('No session selected')));
      return;
    }

    // Update exercises for both planned and actual sessions
    List<TrainingExerciseBus> exercisesToUpdate = [
      ...getSelectedBusinessClass!.trainingSessionExercises,
      ...selectedActualSession!.trainingSessionExercises,
    ];

    updateExercises(exercisesToUpdate, scaffoldMessenger, notify: false);

    // Update the actual session
    isNewActualSession
        ? addBusinessClass(selectedActualSession!, scaffoldMessenger)
        : updateBusinessClass(selectedActualSession!, scaffoldMessenger,
            notify: false);

    // Update the planned session
    updateBusinessClass(getSelectedBusinessClass!, scaffoldMessenger,
        notify: true);

    scaffoldMessenger
        .showSnackBar(SnackBar(content: Text('Session and exercises updated')));
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

  Future<void> addExercise(
    TrainingExerciseBus exercise,
    ScaffoldMessengerState scaffoldMessengerState, {
    bool notify = true,
  }) async {
    String message = "Added ${exercise.getName()}";
    try {
      await exercise.add().onError((error, stackTrace) {
        message = "Error adding ${exercise.getName()}: ${error.toString()}";
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
  void addExerciseToSession(BuildContext context) {
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
    addExercise(newExercise, ScaffoldMessenger.of(context));

    selectedActualSession!.trainingSessionExcercisesIds
        .add(newExercise.trainingExerciseID);
    selectedActualSession!.trainingSessionExercises.add(newExercise);
  }
}
