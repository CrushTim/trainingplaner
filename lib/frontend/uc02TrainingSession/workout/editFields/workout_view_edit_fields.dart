import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/controllers/training_session_edit_fields_controller.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/widgets/training_session_edit_fields_column.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_excercise_row.dart';
import 'package:trainingplaner/services/connectivity_service.dart';

class WorkoutViewEditFields extends StatefulWidget {
  const WorkoutViewEditFields({super.key});

  @override
  State<WorkoutViewEditFields> createState() => _WorkoutViewEditFieldsState();
}

class _WorkoutViewEditFieldsState extends State<WorkoutViewEditFields> {

  late TrainingSessionEditFieldsController controller;
  @override
  void initState() {
    super.initState();

    TrainingSessionProvider trainingSessionProvider = Provider.of<TrainingSessionProvider>(context, listen: false);
    if(trainingSessionProvider.selectedActualSession != null) {
          final session = trainingSessionProvider.selectedActualSession!;
    trainingSessionProvider.selectedSessionDate = session.trainingSessionStartDate;
    }
    controller = TrainingSessionEditFieldsController(trainingSessionProvider, worksOnActual: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
    return Column(
      children: <Widget>[
        const TrainingSessionEditFields(worksOnActual: true),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: true,
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
              if (oldIndex < session.trainingSessionExcercisesIds.length) {
                final exerciseId = session.trainingSessionExcercisesIds.removeAt(oldIndex);
                session.trainingSessionExcercisesIds.insert(
                  newIndex < session.trainingSessionExcercisesIds.length ? newIndex : session.trainingSessionExcercisesIds.length,
                  exerciseId
                );
              }

              // Update the actual session's exercises list
              if (oldIndex < session.trainingSessionExercises.length) {
                final actualExercise = session.trainingSessionExercises.removeAt(oldIndex);
                session.trainingSessionExercises.insert(
                  newIndex < session.trainingSessionExercises.length ? newIndex : session.trainingSessionExercises.length,
                  actualExercise
                );

                // If offline, ensure the moved exercise is in tempExercises
                if (!isOnlinee && !trainingSessionProvider.tempExercises.contains(actualExercise)) {
                  trainingSessionProvider.tempExercises.add(actualExercise);
                }
              }

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
            }
          },
          children: [
            // Get ordered planned exercises
            ...getOrderedExercises(trainingSessionProvider, true).map((exercise) =>
              KeyedSubtree(
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
            
            // Get ordered unplanned exercises
            ...getOrderedExercises(trainingSessionProvider, false).map((exercise) =>
              KeyedSubtree(
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
      // For unplanned exercises and temp exercises
      final exercises = [
        ...provider.exerciseProvider.unplannedExercisesForSession,
        ...provider.tempExercises
      ];
      
      for (int i = 0; i < session.trainingSessionExcercisesIds.length; i++) {
        final id = session.trainingSessionExcercisesIds[i];
        try {
          // First try to find in unplanned exercises
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
