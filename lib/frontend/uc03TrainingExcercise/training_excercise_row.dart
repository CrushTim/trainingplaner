import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/repsWeightsRow/reps_weights_row.dart';

class TrainingExcerciseRow extends StatefulWidget {
  final TrainingExerciseBus? actualTrainingExercise;
  final TrainingExerciseBus? plannedTrainingExercise;
  final Function(TrainingExerciseBus) onUpdate;
  final Function(TrainingExerciseBus) onDelete;
  const TrainingExcerciseRow({
    super.key,
    required this.actualTrainingExercise,
    required this.plannedTrainingExercise,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<TrainingExcerciseRow> createState() => _TrainingExcerciseRowState();
}

class _TrainingExcerciseRowState extends State<TrainingExcerciseRow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    TrainingExerciseBus? actualExercise = widget.actualTrainingExercise;
    actualExercise ??= widget.plannedTrainingExercise!.createActualExercise();

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
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  widget.plannedTrainingExercise?.exerciseName ??
                      widget.actualTrainingExercise!.exerciseName,
                ),
                Text(
                  widget.plannedTrainingExercise?.exerciseFoundationID ??
                      widget.actualTrainingExercise!.exerciseFoundationID,
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
                if (widget.plannedTrainingExercise != null)
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const Text("Planned",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        for (int i = 0;
                            i < widget.plannedTrainingExercise!.exerciseReps.length;
                            i++)
                          Text(
                              "${widget.plannedTrainingExercise!.exerciseReps[i]} x ${widget.plannedTrainingExercise!.exerciseWeights[i]}kg"),
                      ],
                    ),
                  ),
                if (widget.actualTrainingExercise != null)
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const Text("Actual",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        for (int i = 0;
                            i < widget.actualTrainingExercise!.exerciseReps.length;
                            i++)
                          Text(
                              "${widget.actualTrainingExercise!.exerciseReps[i]} x ${widget.actualTrainingExercise!.exerciseWeights[i]}kg"),
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
                    widget.onDelete(actualExercise!);
                  },
                ),
                IconButton(
                  icon: Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
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
                isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Container(),
            secondChild: Column(
              children: [
                for (int i = 0; i < actualExercise.exerciseReps.length; i++)
                  RepsWeightsRow(
                    reps: actualExercise.exerciseReps[i],
                    weight: actualExercise.exerciseWeights[i],
                    onUpdate: (reps, weight) {
                      actualExercise!.exerciseReps[i] = reps;
                      actualExercise.exerciseWeights[i] = weight;
                      setState(() {});
                    },
                    onDelete: () {
                      actualExercise!.exerciseReps.removeAt(i);
                      actualExercise.exerciseWeights.removeAt(i);
                      setState(() {});
                    },
                  ),
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          if (actualExercise!.exerciseWeights.isNotEmpty) {
                            actualExercise.exerciseWeights.add(
                                actualExercise.exerciseWeights[
                                    actualExercise.exerciseWeights.length - 1]);
                            actualExercise.exerciseReps.add(
                                actualExercise.exerciseReps[
                                    actualExercise.exerciseReps.length - 1]);
                          } else {
                            actualExercise.exerciseWeights.add(0);
                            actualExercise.exerciseReps.add(0);
                          }
                          setState(() {});
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          widget.onUpdate(actualExercise!);
                          setState(() {
                            isExpanded = false;
                          });
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
