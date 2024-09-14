import 'package:flutter/material.dart';

class RepsWeightsRow extends StatefulWidget {
  const RepsWeightsRow({
    super.key,
  });

  @override
  State<RepsWeightsRow> createState() => _RepsWeightsRowState();
}

class _RepsWeightsRowState extends State<RepsWeightsRow> {
  TextEditingController repsController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    repsController.text = "5";
    weightController.text = "100";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextField(
            controller: repsController,
            decoration: const InputDecoration(
              labelText: "Reps",
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: TextField(
            controller: weightController,
            decoration: const InputDecoration(
              labelText: "Weight",
            ),
          ),
        ),
        Flexible(
          child: IconButton(
            onPressed: () {
              //TODO implment delete set
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
