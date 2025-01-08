import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/editFields/training_cycle_edit_fields.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';

class TrainingCycleOverviewView extends StatefulWidget {
  const TrainingCycleOverviewView({super.key});

  @override
  State<TrainingCycleOverviewView> createState() => _TrainingCycleOverviewViewState();
}

class _TrainingCycleOverviewViewState extends State<TrainingCycleOverviewView> {
  
  @override
  Widget build(BuildContext context) {
    TrainingCycleProvider trainingCycleProvider = Provider.of<TrainingCycleProvider>(context);
    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Cycles"),
      ),
      body: ListView(children: [
        trainingCycleProvider.getTrainingCycles(),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: trainingCycleProvider,
                  child: const TrainingCycleEditFields(),
                ),
              ),
            );
          },
          child: const Text("Add Cycle"),
        )
      ],)
    );


  }
}
