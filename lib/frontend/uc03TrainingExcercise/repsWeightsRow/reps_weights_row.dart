import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/repsWeightsrow/reps_weights_row_controller.dart';

class RepsWeightsRow extends StatefulWidget {
  final int reps;
  final double weight;
  final Function(int reps, double weight) onUpdate;
  final VoidCallback onDelete;

  const RepsWeightsRow({
    super.key,
    required this.reps,
    required this.weight,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<RepsWeightsRow> createState() => _RepsWeightsRowState();
}

class _RepsWeightsRowState extends State<RepsWeightsRow> {
  late RepsWeightsRowController controller;

  @override
  void initState() {
    super.initState();
    controller = RepsWeightsRowController(
      initialReps: widget.reps,
      initialWeight: widget.weight,
      onUpdate: widget.onUpdate,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            controller: controller.repsController,
            decoration: const InputDecoration(
              labelText: "Reps",
            ),
            onChanged: controller.handleRepsChange,
          ),
        ),
        Expanded(
          flex: 4,
          child: TextField(
            controller: controller.weightController,
            decoration: const InputDecoration(
              labelText: "Weight",
            ),
            onChanged: controller.handleWeightChange,
          ),
        ),
        Flexible(
          child: Checkbox(
            value: controller.isFailure,
            onChanged: (value) {
              setState(() {
                controller.toggleFailure();
              });
            },
          ),
        ),
        Flexible(
          child: IconButton(
            onPressed: widget.onDelete,
            icon: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
