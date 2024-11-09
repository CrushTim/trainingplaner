import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_excercise_row.dart';

class TrainingSessionEditFields extends StatefulWidget {
  const TrainingSessionEditFields({super.key});

  @override
  State<TrainingSessionEditFields> createState() => _TrainingSessionEditFieldsState();
}

class _TrainingSessionEditFieldsState extends State<TrainingSessionEditFields> {



  @override
  Widget build(BuildContext context) {
    print("build");
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
              updateSessionFromFields();
            });
          },
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
            in trainingSessionProvider.getSelectedBusinessClass?.trainingSessionExercises ?? [])
          TrainingExcerciseRow(
            actualTrainingExercise: trainingSessionProvider.plannedToActualExercises[exercise],
            plannedTrainingExercise: exercise,
            onUpdate: (actualExercise) async {
              if (trainingSessionProvider.plannedToActualExercises[exercise] == null) {
                String addId = await trainingSessionProvider.addExercise(
                    actualExercise, ScaffoldMessenger.of(context),
                    notify: false);
                trainingSessionProvider.selectedActualSession!.trainingSessionExcercisesIds.add(addId);
                actualExercise.trainingExerciseID = addId;
                trainingSessionProvider.updateBusinessClass(trainingSessionProvider.selectedActualSession!, ScaffoldMessenger.of(context),
                    notify: false);
              } else {
                trainingSessionProvider.updateExercises([actualExercise], ScaffoldMessenger.of(context),
                    notify: false);
              }
            },
            onDelete: (actualExercise) async{
              if (trainingSessionProvider.plannedToActualExercises[exercise] != null ) {
                  await trainingSessionProvider.deleteExercise(actualExercise, ScaffoldMessenger.of(context));
                
                await trainingSessionProvider.updateBusinessClass(trainingSessionProvider.selectedActualSession!, ScaffoldMessenger.of(context),);
                setState(() {
                  trainingSessionProvider.selectedActualSession!.trainingSessionExcercisesIds
                    .remove(actualExercise.trainingExerciseID);
                trainingSessionProvider.selectedActualSession!.trainingSessionExercises
                    .remove(actualExercise);
                    trainingSessionProvider.plannedToActualExercises.remove(exercise);
                    trainingSessionProvider.getSelectedBusinessClass?.trainingSessionExercises.remove(exercise);
                    trainingSessionProvider.unplannedExercisesForSession.remove(exercise);
                });
              }
            },
          ),

        //add all the unplanned exercises
        for (TrainingExerciseBus exercise in trainingSessionProvider.unplannedExercisesForSession)
          TrainingExcerciseRow(
            actualTrainingExercise: exercise,
            plannedTrainingExercise: null,
            onUpdate: (actualExercise) async{
               await trainingSessionProvider.updateExercises([exercise], ScaffoldMessenger.of(context), notify: false);
            },
            onDelete: (actualExercise) async {
              if (trainingSessionProvider.plannedToActualExercises[exercise] != null ||
                  trainingSessionProvider.unplannedExercisesForSession.contains(exercise)) {
                  await trainingSessionProvider.deleteExercise(actualExercise, ScaffoldMessenger.of(context),
                    notify: false);
                await trainingSessionProvider.updateBusinessClass(trainingSessionProvider.selectedActualSession!, ScaffoldMessenger.of(context),
                    notify: false);
                setState(() {
                  trainingSessionProvider.selectedActualSession!.trainingSessionExcercisesIds
                    .remove(actualExercise.trainingExerciseID);
                trainingSessionProvider.selectedActualSession!.trainingSessionExercises
                    .remove(actualExercise);
                    trainingSessionProvider.plannedToActualExercises.remove(exercise);
                    trainingSessionProvider.getSelectedBusinessClass?.trainingSessionExercises.remove(exercise);
                    trainingSessionProvider.unplannedExercisesForSession.remove(exercise);
                });
              }
            },
          )
      ],
    );
  }
}
