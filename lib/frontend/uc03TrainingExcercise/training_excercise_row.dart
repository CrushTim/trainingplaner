import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/reps_weights_row.dart';

class TrainingExcerciseRow extends StatefulWidget {
  final TrainingExerciseBus? actualTrainingExercise;
  final TrainingExerciseBus? plannedTrainingExercise;
  final Function(bool) onUpdate;
  const TrainingExcerciseRow({
    super.key,
    required this.actualTrainingExercise,
    required this.plannedTrainingExercise,
    required this.onUpdate,
  });

  @override
  State<TrainingExcerciseRow> createState() => _TrainingExcerciseRowState();
}

class _TrainingExcerciseRowState extends State<TrainingExcerciseRow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.actualTrainingExercise == null) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        child: isExpanded
            ? Column(
                children: [
                  //Add rows for each set and rep that are in the actualTrainingExercise
                  for (int i = 0;
                      i < widget.actualTrainingExercise!.exerciseReps.length;
                      i++)
                    RepsWeightsRow(
                      reps: widget.actualTrainingExercise!.exerciseReps[i],
                      weight: i >=
                              widget.actualTrainingExercise!.exerciseReps.length
                          ? 0
                          : widget.actualTrainingExercise!.exerciseWeights[i],
                      onUpdate: (reps, weight) {
                        TrainingExerciseBus? exercise =
                            widget.actualTrainingExercise;
                        bool isNew = exercise == null;
                        exercise ??= widget.plannedTrainingExercise!
                            .createActualExercise();

                        exercise.exerciseReps.add(reps);
                        exercise.exerciseWeights.add(weight);
                        widget.onUpdate(isNew);
                        setState(
                          () {},
                        );
                      },
                      onDelete: () {
                        //TODO: implement delete
                      },
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              widget.actualTrainingExercise!.exerciseReps
                                  .add(0);
                              widget.actualTrainingExercise!.exerciseWeights
                                  .add(0);
                              setState(
                                () {},
                              );
                            },
                            icon: const Icon(Icons.add)),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.arrow_drop_up),
                          onPressed: () {
                            print("Pressed up");

                            bool isNew = widget.actualTrainingExercise == null;

                            TrainingExerciseBus? exercise =
                                widget.actualTrainingExercise;
                            exercise ??= widget.plannedTrainingExercise!
                                .createActualExercise();

                            widget.onUpdate(isNew);
                            setState(() {
                              isExpanded = false;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )
            : IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                          widget.plannedTrainingExercise?.exerciseName ??
                              widget.actualTrainingExercise!.exerciseName),
                    ),
                    const Flexible(
                      child: VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    widget.plannedTrainingExercise != null
                        ? Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                const Text("Planned",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                for (int i = 0;
                                    i <
                                        widget.plannedTrainingExercise!
                                            .exerciseReps.length;
                                    i++)
                                  Text(
                                      "${widget.plannedTrainingExercise!.exerciseReps[i]} x ${widget.plannedTrainingExercise!.exerciseWeights[i]}kg"),
                              ],
                            ))
                        : Container(),
                    widget.actualTrainingExercise != null
                        ? Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                const Text("Actual",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                for (int i = 0;
                                    i <
                                        widget.actualTrainingExercise!
                                            .exerciseReps.length;
                                    i++)
                                  Text(
                                      "${widget.actualTrainingExercise!.exerciseReps[i]} x ${widget.actualTrainingExercise!.exerciseWeights[i]}kg"),
                              ],
                            ))
                        : Container(),
                    const Flexible(
                      child: VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                print("Pressed delete");
                                //TODO: make delit button work/
                              },
                            ),
                          ),
                          Flexible(
                            child: IconButton(
                              icon: const Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                print("Pressed");
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
