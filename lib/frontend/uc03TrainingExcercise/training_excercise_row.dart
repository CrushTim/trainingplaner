import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/reps_weights_row.dart';

class TrainingExerciseRow extends StatefulWidget {
  final TrainingExerciseBus plannedExercise;
  final TrainingExerciseBus? actualExercise;
  final Function(TrainingExerciseBus) onUpdate;

  const TrainingExerciseRow({
    Key? key,
    required this.plannedExercise,
    this.actualExercise,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _TrainingExerciseRowState createState() => _TrainingExerciseRowState();
}

class _TrainingExerciseRowState extends State<TrainingExerciseRow> {
  late TrainingExerciseBus _editableExercise;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _editableExercise =
        widget.actualExercise ?? widget.plannedExercise.createActualExercise();
  }

  void _updateExercise() {
    widget.onUpdate(_editableExercise);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.plannedExercise.exerciseName),
            subtitle: Text(widget.plannedExercise.exerciseDescription),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Column(
              children: [
                ..._editableExercise.exerciseReps.asMap().entries.map((entry) {
                  int index = entry.key;
                  return RepsWeightsRow(
                    reps: _editableExercise.exerciseReps[index],
                    weight: _editableExercise.exerciseWeights[index],
                    onUpdate: (reps, weight) {
                      setState(() {
                        _editableExercise.exerciseReps[index] = reps;
                        _editableExercise.exerciseWeights[index] = weight;
                        _updateExercise();
                      });
                    },
                    onDelete: () {
                      setState(() {
                        _editableExercise.exerciseReps.removeAt(index);
                        _editableExercise.exerciseWeights.removeAt(index);
                        _updateExercise();
                      });
                    },
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _editableExercise.exerciseReps.add(0);
                      _editableExercise.exerciseWeights.add(0.0);
                      _updateExercise();
                    });
                  },
                  child: Text('Add Set'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
