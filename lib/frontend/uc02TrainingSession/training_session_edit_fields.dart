import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_excercise_row.dart';
import 'package:trainingplaner/services/connectivity_service.dart';

class TrainingSessionEditFields extends StatefulWidget {
  const TrainingSessionEditFields({super.key});

  @override
  State<TrainingSessionEditFields> createState() => _TrainingSessionEditFieldsState();
}

class _TrainingSessionEditFieldsState extends State<TrainingSessionEditFields> {
  @override
  Widget build(BuildContext context) {

    ConnectivityService connectivityService = ConnectivityService();
    bool isOnlinee = connectivityService.isConnected;
    connectivityService.connectionStream.listen((bool isOnline) {
      isOnlinee = isOnline;
    });


    TrainingSessionProvider trainingSessionProvider = Provider.of<TrainingSessionProvider>(context);
    final session = trainingSessionProvider.selectedActualSession!;
    final TextEditingController workoutNameController =
        TextEditingController(text: session.trainingSessionName);
    final TextEditingController workoutLengthController =
        TextEditingController(text: session.trainingSessionLength.toString());
    final TextEditingController sessionDescriptionController =
        TextEditingController(text: session.trainingSessionDescription);
    final TextEditingController sessionEmphasisController =
        TextEditingController(text: session.trainingSessionEmphasis.join(','));
    DateTime startDate = session.trainingSessionStartDate;


    return Column(
      children: <Widget>[
        TextField(
          controller: workoutNameController,
          decoration: const InputDecoration(labelText: "Workout Name"),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          onChanged: (_) => trainingSessionProvider.handleSessionFieldChangeForActual('name', _),
        ),
        TextField(
          controller: sessionDescriptionController,
          decoration: const InputDecoration(labelText: "Session Description"),
          onChanged: (_) => trainingSessionProvider.handleSessionFieldChangeForActual('description', _),
        ),
        TextField(
          controller: sessionEmphasisController,
          decoration: const InputDecoration(labelText: "Session Emphasis"),
          onChanged: (_) => trainingSessionProvider.handleSessionFieldChangeForActual('emphasis', _),
        ),
        TextField(
          controller: workoutLengthController,
          decoration:
              const InputDecoration(labelText: "Workout Length in minutes"),
          keyboardType: TextInputType.number,
          onChanged: (_) => trainingSessionProvider.handleSessionFieldChangeForActual('length', _),
        ),
        DropdownButtonFormField<String>(
          value: session.trainingCycleId.isEmpty ? null : session.trainingCycleId,
          decoration: const InputDecoration(labelText: 'Parent Cycle'),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('No Parent'),
            ),
            ...trainingSessionProvider.allCycles.map((cycle) => DropdownMenuItem<String>(
              value: cycle.getId(),
              child: Text(cycle.cycleName),
            )),
          ],
          onChanged: (value) {
            setState(() {
              session.trainingCycleId = value ?? '';
              trainingSessionProvider.handleSessionFieldChangeForActual('cycle', value ?? '');
            });
          },
        ),
        DatePickerSheer(
          initialDateTime: startDate,
          onDateTimeChanged: (DateTime newDateTime) {
            startDate = newDateTime;
            trainingSessionProvider.handleSessionFieldChangeForActual('date', newDateTime.toString());
          },
          dateController: TextEditingController(text: startDate.toString()),
        ),
        // show all the exercises in the session
        for (TrainingExerciseBus exercise in trainingSessionProvider.getSelectedBusinessClass?.trainingSessionExercises ?? [])
          TrainingExcerciseRow(
            actualTrainingExercise: trainingSessionProvider.exerciseProvider.plannedToActualExercises[exercise],
            plannedTrainingExercise: exercise,
            onUpdate: (actualExercise) async {
              ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
              if (trainingSessionProvider.exerciseProvider.plannedToActualExercises[exercise] == null) {
                if(isOnlinee){String addId = await trainingSessionProvider.exerciseProvider.addBusinessClass(
                    actualExercise, scaffoldMessenger,
                    notify: false);
                trainingSessionProvider.selectedActualSession!.trainingSessionExcercisesIds.add(addId);
                actualExercise.trainingExerciseID = addId;
                trainingSessionProvider.updateBusinessClass(trainingSessionProvider.selectedActualSession!, scaffoldMessenger,
                    notify: false);
                }
                } else {
                  if (isOnlinee) {
                    trainingSessionProvider.exerciseProvider.updateBusinessClass(actualExercise, scaffoldMessenger);
                  } else {
                    trainingSessionProvider.tempExercises.add(actualExercise);
                  }
                }
            },
            onDelete: (actualExercise) async{
              ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
              if (trainingSessionProvider.exerciseProvider.plannedToActualExercises[exercise] != null ) {
                setState(() {
                  trainingSessionProvider.selectedActualSession!.trainingSessionExcercisesIds
                    .remove(actualExercise.trainingExerciseID);
                trainingSessionProvider.selectedActualSession!.trainingSessionExercises
                    .remove(actualExercise);
                    trainingSessionProvider.exerciseProvider.plannedToActualExercises.remove(exercise);
                    trainingSessionProvider.getSelectedBusinessClass?.trainingSessionExercises.remove(exercise);
                    trainingSessionProvider.exerciseProvider.unplannedExercisesForSession.remove(exercise);
                });
                if (isOnlinee) {
                await trainingSessionProvider.exerciseProvider.deleteBusinessClass(actualExercise, scaffoldMessenger,
                    notify: false);
                
                await trainingSessionProvider.updateBusinessClass(trainingSessionProvider.selectedActualSession!, scaffoldMessenger,
                    notify: false);
                } else {
                  trainingSessionProvider.tempExercisesToDelete.add(actualExercise);
                }
              }
            },
          ),

        // add all the unplanned exercises
        for (TrainingExerciseBus exercise in trainingSessionProvider.exerciseProvider.unplannedExercisesForSession)
          TrainingExcerciseRow(
            actualTrainingExercise: exercise,
            plannedTrainingExercise: null,
            onUpdate: (actualExercise) async{
              ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
              if (isOnlinee) {
                await trainingSessionProvider.exerciseProvider.updateBusinessClass(actualExercise, scaffoldMessenger);
              } else {
                trainingSessionProvider.tempExercises.add(actualExercise);
              }
            },
            onDelete: (actualExercise) async {
              if (trainingSessionProvider.exerciseProvider.plannedToActualExercises[exercise] != null ||
                  trainingSessionProvider.exerciseProvider.unplannedExercisesForSession.contains(exercise)) {
                  ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

                  setState(() {
                  trainingSessionProvider.selectedActualSession!.trainingSessionExcercisesIds
                    .remove(actualExercise.trainingExerciseID);
                trainingSessionProvider.selectedActualSession!.trainingSessionExercises
                    .remove(actualExercise);
                    trainingSessionProvider.exerciseProvider.plannedToActualExercises.remove(exercise);
                    trainingSessionProvider.getSelectedBusinessClass?.trainingSessionExercises.remove(exercise);
                    trainingSessionProvider.exerciseProvider.unplannedExercisesForSession.remove(exercise);
                });

                  if (isOnlinee) {
                  await trainingSessionProvider.exerciseProvider.deleteBusinessClass(actualExercise, scaffoldMessenger,
                    notify: false);
                await trainingSessionProvider.updateBusinessClass(trainingSessionProvider.selectedActualSession!, scaffoldMessenger,
                    notify: false);
                  } else {
                    trainingSessionProvider.tempExercisesToDelete.add(actualExercise);
                  }

                
              }
            },
          )
      ],
    );
  }
}
