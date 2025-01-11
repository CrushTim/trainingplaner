import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/repsWeightsRow/reps_weights_row.dart';

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
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercise.exerciseName,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(widget.exercise.exerciseFoundationID),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_drop_up),
                      onPressed: () {
                        widget.onUpdate(widget.exercise);
                        setState(() {
                          isExpanded = false;
                        });
                      },
                    ),
                  ),
                  for (int i = 0; i < widget.exercise.exerciseReps.length; i++)
                    
                    RepsWeightsRow(
                      reps: widget.exercise.exerciseReps[i],
                      weight: widget.exercise.exerciseWeights[i],
                      onUpdate: (reps, weight) {
                        widget.exercise.exerciseReps[i] = reps;
                        widget.exercise.exerciseWeights[i] = weight;
                        setState(() {});
                        
                      },
                      onDelete: () {
                        widget.exercise.exerciseReps.removeAt(i);
                        widget.exercise.exerciseWeights.removeAt(i);
                        setState(() {});
                      },
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            if (widget.exercise.exerciseWeights.isNotEmpty) {
                              widget.exercise.exerciseWeights.add(
                                widget.exercise.exerciseWeights[
                                  widget.exercise.exerciseWeights.length - 1],
                              );
                              widget.exercise.exerciseReps.add(widget.exercise.exerciseReps[widget.exercise.exerciseReps.length - 1]);
                            } else {
                              widget.exercise.exerciseWeights.add(0);
                              widget.exercise.exerciseReps.add(0);
                            }
                            setState(() {});
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => widget.onDelete(widget.exercise),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : ListTile(
                title: Text(widget.exercise.exerciseName),
                subtitle: Column(
                  children: [
                    for (int i = 0; i < widget.exercise.exerciseReps.length; i++)
                      Text(
                        "${widget.exercise.exerciseReps[i]}x${widget.exercise.exerciseWeights[i]}kg",
                      ),
                    Text(
                      "${widget.exercise.targetPercentageOf1RM}%",
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
                ),
              ),
      ),
    );
  }
}
