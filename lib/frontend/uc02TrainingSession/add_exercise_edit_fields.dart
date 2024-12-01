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
    var target = provider.exerciseProvider.getSelectedBusinessClass ?? provider.exerciseProvider.businessClassForAdd;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: provider.exerciseProvider.exerciseNameController,
              decoration: const InputDecoration(labelText: 'Exercise Name'),
              onChanged: (value) => provider.exerciseProvider.handleExerciseFieldChange('name', value),
            ),
            TextField(
              controller: provider.exerciseProvider.exerciseDescriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => provider.exerciseProvider.handleExerciseFieldChange('description', value),
            ),
            TextField(
              controller: provider.exerciseProvider.targetPercentageController,
              decoration: const InputDecoration(labelText: 'Target Percentage of 1RM'),
              keyboardType: TextInputType.number,
              onChanged: (value) => provider.exerciseProvider.handleExerciseFieldChange('targetPercentage', value),
            ),
            provider.getFoundationAutoComplete(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    provider.exerciseProvider.resetBusinessClassForAdd();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    
                    // Generate a temporary local ID
                    String tempId = DateTime.now().millisecondsSinceEpoch.toString();
                    target.trainingExerciseID = tempId;
                    
                    // Add to provider's collections using the new method
                    provider.addTemporaryExercise(target);
                    
                    // Close dialog
                    Navigator.pop(context);
                    

                    // Clear form fields
                    provider.exerciseProvider.resetBusinessClassForAdd();
                    provider.exerciseProvider.exerciseNameController.clear();
                    provider.exerciseProvider.exerciseDescriptionController.clear();
                    provider.exerciseProvider.targetPercentageController.clear();
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
