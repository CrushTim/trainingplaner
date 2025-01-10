import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/editFields/training_session_edit_fields.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_excercise_row.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/workout/editFields/workout_view_edit_fields_controller.dart';

class WorkoutViewEditFields extends StatefulWidget {
  const WorkoutViewEditFields({super.key});

  @override
  State<WorkoutViewEditFields> createState() => _WorkoutViewEditFieldsState();
}

class _WorkoutViewEditFieldsState extends State<WorkoutViewEditFields> {
  late WorkoutViewEditFieldsController controller;

  @override
  void initState() {
    super.initState();
    TrainingSessionProvider trainingSessionProvider = 
        Provider.of<TrainingSessionProvider>(context, listen: false);
    controller = WorkoutViewEditFieldsController(trainingSessionProvider);
    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    TrainingSessionProvider trainingSessionProvider = Provider.of<TrainingSessionProvider>(context);
    
    return Column(
      children: <Widget>[
        const TrainingSessionEditFields(worksOnActual: true),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: true,
          onReorder: (oldIndex, newIndex) async {
            setState(() {
              controller.handleReorder(oldIndex, newIndex, context);
            });
          },
          children: [
            ...controller.getOrderedExercises(trainingSessionProvider, true)
                .map((exercise) => _buildExerciseRow(exercise, trainingSessionProvider)),
            ...controller.getOrderedExercises(trainingSessionProvider, false)
                .map((exercise) => _buildUnplannedExerciseRow(exercise, trainingSessionProvider)),
          ],
        ),
      ],
    );
  }

  Widget _buildExerciseRow(exercise, TrainingSessionProvider trainingSessionProvider) {
    return KeyedSubtree(
      key: ValueKey(exercise.trainingExerciseID),
      child: TrainingExcerciseRow(
        actualTrainingExercise: trainingSessionProvider.exerciseProvider.plannedToActualExercises[exercise],
        plannedTrainingExercise: exercise,
        onUpdate: (actualExercise) async {
          await controller.handlePlannedExerciseUpdate(
            exercise,
            actualExercise,
            ScaffoldMessenger.of(context)
          );
        },
        onDelete: (actualExercise) async {
          setState(() {
            controller.handleExerciseDelete(
              exercise,
              actualExercise,
              ScaffoldMessenger.of(context)
            );
          });
        },
      ),
    );
  }

  Widget _buildUnplannedExerciseRow(exercise, TrainingSessionProvider trainingSessionProvider) {
    return KeyedSubtree(
      key: ValueKey(exercise.trainingExerciseID),
      child: TrainingExcerciseRow(
        actualTrainingExercise: exercise,
        plannedTrainingExercise: null,
        onUpdate: (actualExercise) async {
          await controller.handleUnplannedExerciseUpdate(
            actualExercise,
            ScaffoldMessenger.of(context)
          );
        },
        onDelete: (actualExercise) async {
          setState(() {
            controller.handleExerciseDelete(
              exercise,
              actualExercise,
              ScaffoldMessenger.of(context)
            );
          });
        },
      ),
    );
  }
}
