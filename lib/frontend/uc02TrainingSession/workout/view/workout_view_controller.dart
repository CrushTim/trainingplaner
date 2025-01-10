import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/add_exercise_edit_fields.dart';

class WorkoutViewController {
  final TrainingSessionProvider sessionProvider;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController workoutLengthController = TextEditingController();
  final TextEditingController workoutNameController = TextEditingController();
  final TextEditingController sessionDescriptionController = TextEditingController();
  final TextEditingController sessionEmphasisController = TextEditingController();

  WorkoutViewController(this.sessionProvider);

  void initState() {
    startDateController.text = DateTime.now().toString();
    workoutLengthController.text = "60";
    workoutNameController.text = "Workout1 - name - emphasis";
  }

  void dispose() {
    startDateController.dispose();
    workoutLengthController.dispose();
    workoutNameController.dispose();
    sessionDescriptionController.dispose();
    sessionEmphasisController.dispose();
  }

  void handleAddExercise(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: sessionProvider,
        child: const AddExerciseEditFields(),
      ),
    );
  }
} 