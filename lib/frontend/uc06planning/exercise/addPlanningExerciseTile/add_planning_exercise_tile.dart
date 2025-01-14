import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/repsWeightsRow/reps_weights_row.dart';
import 'package:trainingplaner/frontend/uc06planning/exercise/addPlanningExerciseTile/add_planning_exercise_tile_controller.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class AddPlanningExerciseTile extends StatefulWidget {
  final TrainingExerciseBus exercise;
  final Function(TrainingExerciseBus) onUpdate;
  final Function(TrainingExerciseBus) onDelete;

  const AddPlanningExerciseTile({
    super.key,
    required this.exercise,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<AddPlanningExerciseTile> createState() => _AddPlanningExerciseTileState();
}

class _AddPlanningExerciseTileState extends State<AddPlanningExerciseTile> {
  late AddPlanningExerciseTileController controller;

  @override
  void initState() {
    super.initState();
    controller = AddPlanningExerciseTileController(
      Provider.of<PlanningProvider>(context, listen: false)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            title: Column(
              children: [
                Text(
                  controller.getExerciseDisplayText(widget.exercise),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  controller.getExerciseFoundationID(widget.exercise),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(controller.getArrowIcon()),
                  onPressed: () {
                    setState(() {
                      controller.toggleExpanded();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    widget.onDelete(widget.exercise);
                  },
                ),
              ],
            ),
          ),
          if (controller.isExpanded) ...[
            for (int i = 0; i < widget.exercise.exerciseReps.length; i++)
              RepsWeightsRow(
                reps: widget.exercise.exerciseReps[i],
                weight: widget.exercise.exerciseWeights[i],
                onUpdate: (reps, weight) {
                  controller.updateRepsAndWeight(widget.exercise, i, reps, weight);
                  widget.onUpdate(widget.exercise);
                },
                onDelete: () {
                  controller.deleteRepsAndWeight(widget.exercise, i);
                  widget.onUpdate(widget.exercise);
                  setState(() {});
                },
              ),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      controller.addNewSet(widget.exercise);
                      widget.onUpdate(widget.exercise);
                      setState(() {});
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      widget.onUpdate(widget.exercise);
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
} 