import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_exercise_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class AddExerciseEditFields extends StatefulWidget {
  final bool addPlanned;
  const AddExerciseEditFields({super.key, this.addPlanned = false});

  @override
  State<AddExerciseEditFields> createState() => _AddExerciseEditFieldsState();
}

class _AddExerciseEditFieldsState extends State<AddExerciseEditFields> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TrainingExerciseProvider trainingExerciseProvider = widget.addPlanned == false ? Provider.of<TrainingSessionProvider>(context).exerciseProvider : Provider.of<PlanningProvider>(context).exerciseProvider;
    var target = trainingExerciseProvider.getSelectedBusinessClass ?? trainingExerciseProvider.businessClassForAdd;

    if(widget.addPlanned) {
      target.isPlanned = true;
    }

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: trainingExerciseProvider.exerciseNameController,
              decoration: const InputDecoration(labelText: 'Exercise Name'),
              onChanged: (value) => trainingExerciseProvider.handleExerciseFieldChange('name', value),
            ),
            TextField(
              controller: trainingExerciseProvider.exerciseDescriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => trainingExerciseProvider.handleExerciseFieldChange('description', value),
            ),
            TextField(
              controller: trainingExerciseProvider.targetPercentageController,
              decoration: const InputDecoration(labelText: 'Target Percentage of 1RM'),
              keyboardType: TextInputType.number,
              onChanged: (value) => trainingExerciseProvider.handleExerciseFieldChange('targetPercentage', value),
            ),
            trainingExerciseProvider.getFoundationAutoComplete(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    trainingExerciseProvider.resetBusinessClassForAdd();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    TrainingExerciseBus? exercise;
                    // Add to provider's collections using the appropriate provider
                    if (widget.addPlanned) {
                      exercise = await Provider.of<PlanningProvider>(context, listen: false)
                          .addTemporaryExercise(target, notify: false);
                      
                    } else {
                      exercise = await Provider.of<TrainingSessionProvider>(context, listen: false)
                          .addTemporaryExercise(target);
                    }
                    
                    // Close dialog
                    if(context.mounted) {
                      Navigator.pop(context, exercise);
                    }
                    
                    // Clear form fields
                    trainingExerciseProvider.exerciseNameController.clear();
                    trainingExerciseProvider.exerciseDescriptionController.clear();
                    trainingExerciseProvider.targetPercentageController.clear();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}


