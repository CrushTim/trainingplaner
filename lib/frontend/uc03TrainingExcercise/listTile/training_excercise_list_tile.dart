import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/listTile/training_exercise_list_tile_controller.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/repsWeightsRow/reps_weights_row.dart';

class TrainingExerciseListTile extends StatefulWidget {
  final TrainingExerciseBus? actualTrainingExercise;
  final TrainingExerciseBus? plannedTrainingExercise;
  final Function(TrainingExerciseBus) onUpdate;
  final Function(TrainingExerciseBus) onDelete;
  const TrainingExerciseListTile({
    super.key,
    required this.actualTrainingExercise,
    required this.plannedTrainingExercise,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<TrainingExerciseListTile> createState() => _TrainingExerciseListTileState();
}

class _TrainingExerciseListTileState extends State<TrainingExerciseListTile> {
  late TrainingExerciseListTileController controller;

  @override
  void initState() {
    super.initState();
    controller = TrainingExerciseListTileController(plannedExercise: widget.plannedTrainingExercise, actualExercise: widget.actualTrainingExercise);
  }

  @override
  Widget build(BuildContext context) {
    controller.setActualExercise();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Title section that's always visible
          ListTile(
            title: Column(
              children: [
                Text(
                  controller.getExerciseDisplayText(),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  controller.getExerciseFoundationID(),
                ),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Flexible(
                  child: VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                if (controller.plannedExercise != null)
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const Text("Planned",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...controller.getAllTextsForPlannedExercise(),
                      ],
                    ),
                  ),
                if (controller.actualExercise != null)
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const Text("Actual",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...controller.getAllTextsForActualExercise(),
                      ],
                    ),
                  ),
                const Flexible(
                  child: VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    widget.onDelete(controller.actualExercise!);
                  },
                ),
                IconButton(
                  icon: Icon(controller.getArrowIcon()),
                  onPressed: () {
                    setState(() {
                      controller.toggleExpanded();
                    });
                  },
                ),
              ],
            ),
          ),
          // Expandable section
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState:
                controller.isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Container(),
            secondChild: Column(
              children: [
                for (int i = 0; i < controller.actualExercise!.exerciseReps.length; i++)
                  RepsWeightsRow(
                    reps: controller.actualExercise!.exerciseReps[i],
                    weight: controller.actualExercise!.exerciseWeights[i],
                    onUpdate: (reps, weight) {
                       controller.updateRepsAndWeight(i, reps, weight);
                       setState(() {});
                      },
                    onDelete: () {
                      controller.deleteRepsAndWeight(i);
                      setState(() {});
                    },
                  ),
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          controller.addNewSet();
                          setState(() {});
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          widget.onUpdate(controller.actualExercise!);
                          controller.toggleExpanded();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
