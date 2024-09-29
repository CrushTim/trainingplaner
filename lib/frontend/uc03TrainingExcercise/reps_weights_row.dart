import 'package:flutter/material.dart';

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
  late TextEditingController repsController;
  late TextEditingController weightController;
  late bool isFailure;

  @override
  void initState() {
    super.initState();
    repsController = TextEditingController(text: widget.reps.toString());
    weightController = TextEditingController(text: widget.weight.toString());
    isFailure = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            controller: repsController,
            decoration: const InputDecoration(
              labelText: "Reps",
            ),
            onChanged: (value) {
              int? reps = int.tryParse(value);
              if (reps != null) {
                widget.onUpdate(reps, widget.weight);
              }
            },
          ),
        ),
        Expanded(
          flex: 4,
          child: TextField(
            controller: weightController,
            decoration: const InputDecoration(
              labelText: "Weight",
            ),
            onChanged: (value) {
              double? weight = double.tryParse(value);
              if (weight != null) {
                widget.onUpdate(widget.reps, weight);
              }
            },
          ),
        ),
        Flexible(
          child: Checkbox(
            value: isFailure,
            onChanged: (value) {
              setState(() {
                isFailure = value ?? false;
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
