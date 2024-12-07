import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/reps_weights_row.dart';

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
      child: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        child: isExpanded
            ? Column(
                children: [
                  //Add rows for each set and rep that are in the actualTrainingExercise
                  for (int i = 0; i < actualExercise.exerciseReps.length; i++)
                    RepsWeightsRow(
                      reps: actualExercise.exerciseReps[i],
                      weight: i >= actualExercise.exerciseReps.length
                          ? 0
                          : actualExercise.exerciseWeights[i],
                      onUpdate: (reps, weight) {
                        actualExercise!.exerciseReps[i] = reps;
                        actualExercise.exerciseWeights[i] = weight;
                        setState(
                          () {},
                        );
                      },
                      onDelete: () {
                        actualExercise!.exerciseReps.removeAt(i);
                        actualExercise.exerciseWeights.removeAt(i);
                        setState(
                          () {},
                        );
                      },
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              actualExercise!.exerciseReps.add(0);
                              if(actualExercise.exerciseWeights.length > 1){
                                actualExercise.exerciseWeights.add(actualExercise.exerciseWeights[actualExercise.exerciseWeights.length - 1]);
                              }else{
                                actualExercise.exerciseWeights.add(0);
                              }
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
                            widget.onUpdate(actualExercise!);
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
            : ListTile(
              title: Column(
                children: [
                        Text(
                          style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          widget.plannedTrainingExercise?.exerciseName ??
                              widget.actualTrainingExercise!.exerciseName,
                        ),
                        Text(
                          widget.plannedTrainingExercise?.exerciseFoundationID ??
                              widget.actualTrainingExercise!.exerciseFoundationID,
                        ),
                      
                  
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),]),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      
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
                      
                    ],
                  ),
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              widget.onDelete(actualExercise!);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                          ),
                        ],
                      ),
            ),
      ),
    );
  }
}
