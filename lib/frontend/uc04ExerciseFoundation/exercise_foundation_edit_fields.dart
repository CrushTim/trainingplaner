import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';

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
                controller: provider.nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => provider.handleTextFieldChange('name', value),
              ),
              TextField(
                controller: provider.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => provider.handleTextFieldChange('description', value),
              ),
              TextField(
                controller: provider.picturePathController,
                decoration: const InputDecoration(labelText: 'Picture Path'),
                onChanged: (value) => provider.handleTextFieldChange('picturePath', value),
              ),
              TextField(
                controller: provider.categoriesController,
                decoration: const InputDecoration(labelText: 'Categories (comma-separated)'),
                onChanged: (value) => provider.handleTextFieldChange('categories', value),
              ),
              TextField(
                controller: provider.muscleGroupsController,
                decoration: const InputDecoration(labelText: 'Muscle Groups (comma-separated)'),
                onChanged: (value) => provider.handleTextFieldChange('muscleGroups', value),
              ),
              TextField(
                controller: provider.amountOfPeopleController,
                decoration: const InputDecoration(labelText: 'Amount of People'),
                keyboardType: TextInputType.number,
                onChanged: (value) => provider.handleTextFieldChange('amountOfPeople', value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  provider.saveExerciseFoundation(ScaffoldMessenger.of(context));
                  Navigator.pop(context);
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
