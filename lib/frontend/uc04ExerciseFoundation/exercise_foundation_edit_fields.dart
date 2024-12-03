import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/user_specific_one_rep_max_edit_fields.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/user_specific_one_rep_max_list_tile.dart';
class ExerciseFoundationEditFields extends StatefulWidget {
  const ExerciseFoundationEditFields({super.key});

  @override
  State<ExerciseFoundationEditFields> createState() => _ExerciseFoundationEditFieldsState();
}

class _ExerciseFoundationEditFieldsState extends State<ExerciseFoundationEditFields> {
  @override
  void initState() {
    super.initState();
    Provider.of<ExerciseFoundationProvider>(context, listen: false).initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExerciseFoundationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.getSelectedBusinessClass == null ? "Add Exercise Foundation" : "Edit Exercise Foundation"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                readOnly: true,
                controller: provider.nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => provider.handleTextFieldChange('name', value),
              ),
              TextField(
                readOnly: true,
                controller: provider.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => provider.handleTextFieldChange('description', value),
              ),
              TextField(
                readOnly: true,
                controller: provider.picturePathController,
                decoration: const InputDecoration(labelText: 'Picture Path'),
                onChanged: (value) => provider.handleTextFieldChange('picturePath', value),
              ),
              TextField(
                readOnly: true,
                controller: provider.categoriesController,
                decoration: const InputDecoration(labelText: 'Categories (comma-separated)'),
                onChanged: (value) => provider.handleTextFieldChange('categories', value),
              ),
              TextField(
                readOnly: true,
                controller: provider.muscleGroupsController,
                decoration: const InputDecoration(labelText: 'Muscle Groups (comma-separated)'),
                onChanged: (value) => provider.handleTextFieldChange('muscleGroups', value),
              ),
              TextField(
                readOnly: true,
                controller: provider.amountOfPeopleController,
                decoration: const InputDecoration(labelText: 'Amount of People'),
                keyboardType: TextInputType.number,
                onChanged: (value) => provider.handleTextFieldChange('amountOfPeople', value),
              ),
              TextField(
                controller: provider.notesController,
                decoration: const InputDecoration(labelText: 'Notes (comma-separated)'),
                onChanged: (value) => provider.handleTextFieldChange('notes', value),
              ),
              provider.userSpecificExercise.isEmpty ? const Text("No 1 Rep max data available") : Column(
                children: provider.userSpecificExercise.map((userSpecificExercise) {
                  return UserSpecificOneRepMaxListTile(userSpecificExercise: userSpecificExercise);
                }).toList(),
              ),
              ElevatedButton(onPressed: () async {
                provider.userSpecificExerciseBusForAdd.foundationId = provider.getSelectedBusinessClass!.getId();
                provider.initialDateTime = provider.userSpecificExerciseBusForAdd.date;
                await showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) => ChangeNotifierProvider.value(
                    value: provider,
                    child: Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserSpecificOneRepMaxEditFields(
                            userSpecificExercise: provider.userSpecificExerciseBusForAdd
                          )
                        ],
                      ),
                    ),
                  ),
                ).then((_) { 
                  if (_ == true) {
                    provider.userSpecificExercise.add(provider.userSpecificExerciseBusForAdd);
                    setState(() {});
                  }
                  
                provider.initialDateTime = DateTime.now();
                provider.resetUserSpecificExerciseForAdd();
                provider.resetSelectedUserSpecificExercise();
                
                });
              }, child: const Text("Add 1 Rep Max")),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await provider.saveExerciseFoundation(ScaffoldMessenger.of(context));
                  if(context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
