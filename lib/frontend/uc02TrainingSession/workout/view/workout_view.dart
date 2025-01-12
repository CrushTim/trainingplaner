import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/workout/selection/workout_selection_view.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/workout/view/workout_view_controller.dart';

///
/// This class represents the view of a workout.
/// It represents the current Trainingsession with all excercises and sets.
/// It is Used in the HomePage to display the current workout.
/// It makes the user able to add new excercises to the workout and to finish the workout in the Excercise diary.
///
class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  late WorkoutViewController controller;

  @override
  void initState() {
    super.initState();
    TrainingSessionProvider sessionProvider = 
        Provider.of<TrainingSessionProvider>(context, listen: false);
    controller = WorkoutViewController(sessionProvider);
    controller.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TrainingSessionProvider sessionProvider =
        Provider.of<TrainingSessionProvider>(context);
        
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout"), 
      ),
      body: ListView(
        children: [
          sessionProvider.getCurrentTrainingSessionStreamBuilder(),
          IconButton(
            onPressed: () => controller.handleAddExercise(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: sessionProvider,
                child: const WorkoutSelectionView(),
              ),
            ),
          );
        },
        child: const Icon(Icons.list),
      ),
    );
  }
}
