import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/reports/training_exercise_bus_report.dart';
import 'package:trainingplaner/business/reports/training_session_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';

class TrainingSessionProvider extends TrainingsplanerProvider<
    TrainingSessionBus, TrainingSessionBusReport> {
  ///the report task for the exercises to get the exercises from the database
  ///and map them to the session
  TrainingExerciseBusReport trainingExerciseBusReport =
      TrainingExerciseBusReport();

  TrainingSessionProvider()
      : super(
            businessClassForAdd: TrainingSessionBus(
                trainingSessionId: "",
                isPlanned: true,
                trainingSessionName: "",
                trainingSessionDescription: "",
                trainingSessionEmphasis: "",
                trainingSessionExcercisesIds: [],
                trainingSessionLength: 1,
                trainingSessionStartDate: DateTime.now(),
                trainingCycleId: ""),
            reportTaskVar: TrainingSessionBusReport());

  StreamBuilder<List<TrainingSessionBus>>
      getAllTrainingSessionsStreamBuilder() {
    return StreamBuilder<List<TrainingSessionBus>>(
      stream: reportTaskVar.getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Text(snapshot.data![index].trainingSessionName);
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildTrainingSessionEditFields() {
    if (getSelectedBusinessClass == null) {
      return Text("No training session selected");
    }

    final session = getSelectedBusinessClass!;
    final TextEditingController workoutNameController =
        TextEditingController(text: session.trainingSessionName);
    final TextEditingController workoutLengthController =
        TextEditingController(text: session.trainingSessionLength.toString());
    final TextEditingController sessionDescriptionController =
        TextEditingController(text: session.trainingSessionDescription);
    final TextEditingController sessionEmphasisController =
        TextEditingController(text: session.trainingSessionEmphasis);
    DateTime startDate = session.trainingSessionStartDate;

    void updateSession() {
      session.trainingSessionName = workoutNameController.text;
      session.trainingSessionLength =
          int.tryParse(workoutLengthController.text) ??
              session.trainingSessionLength;
      session.trainingSessionDescription = sessionDescriptionController.text;
      session.trainingSessionEmphasis = sessionEmphasisController.text;
      session.trainingSessionStartDate = startDate;
    }

    return Column(
      children: [
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
          return CircularProgressIndicator();
        } else if (snapshots.snapshot1.hasError ||
            snapshots.snapshot2.hasError) {
          return Text("Error");
        } else {
          List<TrainingSessionBus> trainingSessions = snapshots.snapshot1.data!;
          List<TrainingExerciseBus> trainingExercises =
              snapshots.snapshot2.data!;

          for (TrainingSessionBus trainingSession in trainingSessions) {
            trainingSession.trainingSessionExercises = trainingExercises
                .where((exercise) =>
                    exercise.trainingExerciseID ==
                    trainingSession.trainingSessionId)
                .toList();
          }

          // Assuming you want to display the first session
          // You might want to implement a way to select a specific session
          if (trainingSessions.isNotEmpty) {
            setSelectedBusinessClass(trainingSessions.first);
            return buildTrainingSessionEditFields();
          } else {
            return Text("No training sessions available");
          }
        }
      },
    );
  }
}
