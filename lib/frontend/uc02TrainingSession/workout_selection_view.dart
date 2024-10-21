import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

///class for the workout selection view
///is used to select a workout from a list of all workouts
///is called from the workout view
class WorkoutSelectionView extends StatelessWidget {
  const WorkoutSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<TrainingSessionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Selection"),
      ),
      body: sessionProvider.getAllSessionsForWorkoutView(),
    );
  }
}