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
  late bool isFailure;

  @override
  void initState() {
    super.initState();
    repsController.text = "5";
    weightController.text = "100";
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
          ),
        ),
        Expanded(
          flex: 4,
          child: TextField(
            controller: weightController,
            decoration: const InputDecoration(
              labelText: "Weight",
            ),
          ),
        ),
        Flexible(
          child: Checkbox(
            value: isFailure,
            onChanged: (value) {
              //TODO implement checkbox
              setState(() {
                isFailure = !isFailure;
              });
              print(isFailure);
            },
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
