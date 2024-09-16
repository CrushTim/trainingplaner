import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/add_training_cycle_view.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/cycle_draggable.dart';

class EditCyclesView extends StatefulWidget {
  const EditCyclesView({super.key});

  @override
  State<EditCyclesView> createState() => _EditCyclesViewState();
}

class _EditCyclesViewState extends State<EditCyclesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Cycles"),
      ),
      body: ListView(
        children: List<Widget>.generate(3, (index) {
              return CycleDraggable(
                index: index,
              );
            }) +
            [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddTrainingCycleView()));
                },
                child: const Text("Add Cycle"),
              ),
            ],
      ),
    );
  }
}
