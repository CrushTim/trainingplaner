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
  void initState() {
    super.initState();

    TrainingSessionProvider trainingSessionProvider = Provider.of<TrainingSessionProvider>(context, listen: false);
    if(trainingSessionProvider.selectedActualSession != null) {
          final session = trainingSessionProvider.selectedActualSession!;
    trainingSessionProvider.selectedSessionDate = session.trainingSessionStartDate;
    }
  }
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

        print("session ${session.trainingSessionExcercisesIds}");

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
          initialDateTime: trainingSessionProvider.selectedSessionDate,
          onDateTimeChanged: trainingSessionProvider.updateSessionDate,
          dateController: TextEditingController(text: trainingSessionProvider.selectedSessionDate.toString()),
        ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorder: (oldIndex, newIndex) async {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            
            setState(() {
              // Get all exercises in their current order
              final allExercises = [
                ...getOrderedExercises(trainingSessionProvider, true),
                ...getOrderedExercises(trainingSessionProvider, false)
              ];
              final exerciseToMove = allExercises[oldIndex];
              
              // Update the IDs list
              final exerciseId = session.trainingSessionExcercisesIds.removeAt(oldIndex);
              session.trainingSessionExcercisesIds.insert(newIndex, exerciseId);

              // Update the actual session's exercises list
              final actualExercise = session.trainingSessionExercises.removeAt(oldIndex);
              session.trainingSessionExercises.insert(newIndex, actualExercise);

              // Update the planned exercises list if it exists and the exercise is planned
              if (trainingSessionProvider.getSelectedBusinessClass != null && 
                  trainingSessionProvider.getSelectedBusinessClass!.trainingSessionExercises.contains(exerciseToMove)) {
                final plannedIndex = trainingSessionProvider.getSelectedBusinessClass!.trainingSessionExercises
                    .indexOf(exerciseToMove);
                final exercise = trainingSessionProvider.getSelectedBusinessClass!.trainingSessionExercises
                    .removeAt(plannedIndex);
                trainingSessionProvider.getSelectedBusinessClass!.trainingSessionExercises
                    .insert(newIndex, exercise);
              }
              
              // Update unplanned exercises list if necessary
              if (trainingSessionProvider.exerciseProvider.unplannedExercisesForSession.contains(exerciseToMove)) {
                final unplannedIndex = trainingSessionProvider.exerciseProvider.unplannedExercisesForSession
                    .indexOf(exerciseToMove);
                final exercise = trainingSessionProvider.exerciseProvider.unplannedExercisesForSession
                    .removeAt(unplannedIndex);
                trainingSessionProvider.exerciseProvider.unplannedExercisesForSession
                    .insert(newIndex, exercise);
              }
            });

            if (isOnlinee) {
              await trainingSessionProvider.updateBusinessClass(
                session, 
                ScaffoldMessenger.of(context), 
                notify: false
              );
            } else {
              trainingSessionProvider.tempExercises.add(session.trainingSessionExercises[newIndex]);
            }
          },
          children: [
            // Get ordered planned exercises
            ...getOrderedExercises(trainingSessionProvider, true).map((exercise) =>
              ReorderableDragStartListener(
                key: ValueKey(exercise.trainingExerciseID),
                index: getOrderedExercises(trainingSessionProvider, true).indexOf(exercise),
                child: KeyedSubtree(
                  key: ValueKey(exercise.trainingExerciseID),
                  child: TrainingExcerciseRow(
                    actualTrainingExercise: trainingSessionProvider.exerciseProvider.plannedToActualExercises[exercise],
                    plannedTrainingExercise: exercise,
                    onUpdate: (actualExercise) async {
                      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
                      if (trainingSessionProvider.exerciseProvider.plannedToActualExercises[exercise] == null) {
                        if(isOnlinee) {
                          String addId = await trainingSessionProvider.exerciseProvider.addBusinessClass(
                              actualExercise, 
                              scaffoldMessenger,
                              notify: false);
                          session.trainingSessionExcercisesIds.add(addId);
                          actualExercise.trainingExerciseID = addId;
                          trainingSessionProvider.updateBusinessClass(
                              trainingSessionProvider.selectedActualSession!, 
                              scaffoldMessenger,
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
                    onDelete: (actualExercise) async {
                      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
                      if (trainingSessionProvider.exerciseProvider.plannedToActualExercises[exercise] != null) {
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
                          await trainingSessionProvider.exerciseProvider.deleteBusinessClass(
                            actualExercise, 
                            scaffoldMessenger,
                            notify: false
                          );
                          await trainingSessionProvider.updateBusinessClass(
                            trainingSessionProvider.selectedActualSession!, 
                            scaffoldMessenger,
                            notify: false
                          );
                        } else {
                          trainingSessionProvider.tempExercisesToDelete.add(actualExercise);
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            
            // Get ordered unplanned exercises
            ...getOrderedExercises(trainingSessionProvider, false).map((exercise) =>
              ReorderableDragStartListener(
                key: ValueKey(exercise.trainingExerciseID),
                index: getOrderedExercises(trainingSessionProvider, true).length + 
                       getOrderedExercises(trainingSessionProvider, false).indexOf(exercise),
                child: KeyedSubtree(
                  key: ValueKey(exercise.trainingExerciseID),
                  child: TrainingExcerciseRow(
                    actualTrainingExercise: exercise,
                    plannedTrainingExercise: null,
                    onUpdate: (actualExercise) async {
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<TrainingExerciseBus> getOrderedExercises(
      TrainingSessionProvider provider,
      bool planned) {
    final session = provider.selectedActualSession!;
    final List<TrainingExerciseBus?> orderedExercises = List.filled(
      session.trainingSessionExcercisesIds.length,
      null
    );
    
    if (planned) {
      // For planned exercises
      if (provider.getSelectedBusinessClass?.trainingSessionExercises != null) {
        final exercises = provider.getSelectedBusinessClass!.trainingSessionExercises;
        for (int i = 0; i < session.trainingSessionExcercisesIds.length; i++) {
          final id = session.trainingSessionExcercisesIds[i];
          try {
            final exercise = exercises.firstWhere((e) => e.trainingExerciseID == id);
            orderedExercises[i] = exercise;
          } catch (e) {
            continue;
          }
        }
      }
    } else {
      // For unplanned exercises
      final exercises = provider.exerciseProvider.unplannedExercisesForSession;
      for (int i = 0; i < session.trainingSessionExcercisesIds.length; i++) {
        final id = session.trainingSessionExcercisesIds[i];
        try {
          final exercise = exercises.firstWhere((e) => e.trainingExerciseID == id);
          orderedExercises[i] = exercise;
        } catch (e) {
          continue;
        }
      }
    }

    // Remove any null entries (exercises that weren't found)
    return orderedExercises.whereType<TrainingExerciseBus>().toList();
  }
}
