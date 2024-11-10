import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class AddExerciseEditFields extends StatefulWidget {
  const AddExerciseEditFields({super.key});

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
    final provider = Provider.of<TrainingSessionProvider>(context);
    var target = provider.selectedExercise ?? provider.exerciseForAdd;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: provider.exerciseNameController,
              decoration: const InputDecoration(labelText: 'Exercise Name'),
              onChanged: (value) => provider.handleExerciseFieldChange('name', value),
            ),
            TextField(
              controller: provider.exerciseDescriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => provider.handleExerciseFieldChange('description', value),
            ),
            TextField(
              controller: provider.targetPercentageController,
              decoration: const InputDecoration(labelText: 'Target Percentage of 1RM'),
              keyboardType: TextInputType.number,
              onChanged: (value) => provider.handleExerciseFieldChange('targetPercentage', value),
            ),
            provider.getFoundationAutoComplete(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    provider.resetExerciseForAdd();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String exerciseId = await provider.addExercise(
                      target,
                      ScaffoldMessenger.of(context),
                      notify: false,
                    );
                    provider.selectedActualSession!.trainingSessionExcercisesIds.add(exerciseId);
                    target.trainingExerciseID = exerciseId;
                    provider.selectedActualSession!.trainingSessionExercises.add(target);
                    await provider.updateBusinessClass(
                      provider.selectedActualSession!,
                      ScaffoldMessenger.of(context),
                      notify: true,
                    );
                    provider.resetExerciseForAdd();
                    provider.selectedExercise = null;
                    provider.exerciseNameController.clear();
                    provider.exerciseDescriptionController.clear();
                    provider.targetPercentageController.clear();
                    Navigator.pop(context);
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
