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

  Map<TrainingSessionBus, TrainingSessionBus?> plannedToActualSessions = {};
  Map<TrainingExerciseBus, TrainingExerciseBus?> plannedToActualExercises = {};

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

  /// Builds the training session edit fields
  ///
  /// Returns a widget that allows the user to edit the training session fields
  ///
  /// If no training session is selected, returns a text saying so
  ///
  Widget buildTrainingSessionEditFields() {
    if (getSelectedBusinessClass == null) {
      return const Text("No training session selected");
    }

    final session = getSelectedBusinessClass!;
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
        ...getSelectedBusinessClass!.trainingSessionExercises
            .map((plannedExercise) {
          return TrainingExerciseRow(
            plannedExercise: plannedExercise,
            actualExercise: plannedToActualExercises[plannedExercise],
            onUpdate: (updatedExercise) {
              plannedToActualExercises[plannedExercise] = updatedExercise;
              // You might want to call a method here to persist changes or update state
            },
          );
        })
      ],
    );
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
            print("1");
            return Text(snapshots.snapshot1.error.toString());
          } else {
            return Text(snapshots.snapshot2.error.toString());
          }
        } else {
          List<TrainingSessionBus> allSessions = snapshots.snapshot1.data!;
          List<TrainingExerciseBus> allExercises = snapshots.snapshot2.data!;
          print(allSessions.length);

          // Clear and rebuild the maps
          plannedToActualSessions.clear();
          plannedToActualExercises.clear();

          // Map all sessions (planned and actual)
          for (var session in allSessions) {
            if (session.isPlanned) {
              plannedToActualSessions[session] = null;
            } else {
              var plannedSession = allSessions.firstWhere(
                (s) => s.trainingSessionId == session.plannedSessionId,
                orElse: () => session,
              );
              plannedToActualSessions[plannedSession] = session;
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
              plannedToActualExercises[plannedExercise] = exercise;
            }
          }

          // Assign exercises to sessions
          for (var session in allSessions) {
            session.trainingSessionExercises = allExercises
                .where((exercise) => session.trainingSessionExcercisesIds
                    .contains(exercise.trainingExerciseID))
                .toList();
          }

          // Assuming you want to display the first session
          if (allSessions.isNotEmpty) {
            setSelectedBusinessClass(allSessions.first, notify: false);
            return buildTrainingSessionEditFields();
          } else {
            return const Text("No training sessions available");
          }
        }
      },
    );
  }

  /// Updates the session and its exercises
  ///
  /// If the session is planned, it checks if there is an actual session for it.
  /// If not, it creates one. Then it updates or creates the exercises in the session.
  /// Finally, it updates the session in the database.
  void updateSessionInDatabase(
      TrainingSessionBus? session, ScaffoldMessengerState scaffoldMessenger) {
    if (session == null) {
      return;
    }
    if (session.isPlanned) {
      TrainingSessionBus? actualSession = plannedToActualSessions[session];
      //if there is no actual session for the planned session, create one
      if (actualSession == null) {
        actualSession = session.createActualSession();
        plannedToActualSessions[session] = actualSession;
        addBusinessClass(actualSession, scaffoldMessenger);
      }
      //go through all the planned exercises and update or create the actual exercises
      for (var plannedExercise in session.trainingSessionExercises) {
        var actualExercise = plannedToActualExercises[plannedExercise];

        if (actualExercise != null) {
          // Update existing actual exercise
          ///actualExercise.exerciseReps = plannedExercise.exerciseReps;
          //actualExercise.exerciseWeights = plannedExercise.exerciseWeights;
          // TODO: Update this actual exercise in the database
        } else {
          // Create new actual exercise
          actualExercise = plannedExercise.createActualExercise();
          plannedToActualExercises[plannedExercise] = actualExercise;
          actualSession.trainingSessionExcercisesIds
              .add(actualExercise.trainingExerciseID);
          // TODO: Add this actual exercise to the database
        }
      }

      updateBusinessClass(actualSession, scaffoldMessenger, notify: false);
    }

    updateBusinessClass(session, scaffoldMessenger, notify: false);
    setSelectedBusinessClass(session);
  }
}
