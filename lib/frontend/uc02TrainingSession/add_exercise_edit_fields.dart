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
                  onPressed: () {
                    // Generate a temporary local ID (you can use UUID or timestamp)
                    String tempId = DateTime.now().millisecondsSinceEpoch.toString();
                    
                    // Set the temporary ID
                    target.trainingExerciseID = tempId;
                    
                    // Add to local collections first
                    provider.selectedActualSession!.trainingSessionExcercisesIds.add(tempId);
                    provider.selectedActualSession!.trainingSessionExercises.add(target);
                    
                    // Trigger the async operation in the background
                    provider.addExercise(
                      target,
                      ScaffoldMessenger.of(context),
                      notify: false,
                    ).then((String permanentId) {
                      // Update the local references with the permanent ID
                      int index = provider.selectedActualSession!.trainingSessionExcercisesIds.indexOf(tempId);
                      if (index != -1) {
                        provider.selectedActualSession!.trainingSessionExcercisesIds[index] = permanentId;
                        target.trainingExerciseID = permanentId;
                      }
                      
                      // Update the session in the background
                      provider.updateBusinessClass(
                        provider.selectedActualSession!,
                        ScaffoldMessenger.of(context),
                        notify: true,
                      );
                    }).catchError((error) {
                      // Handle error - maybe show a sync failed message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to sync: ${error.toString()}')),
                      );
                    });

                    // Clear the form
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
