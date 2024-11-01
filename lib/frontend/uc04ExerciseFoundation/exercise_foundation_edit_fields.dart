import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';
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
              provider.userSpecificExercise.isEmpty ? const Text("No 1 Rep max data available") : Column(
                children: provider.userSpecificExercise.map((userSpecificExercise) {
                  //TODO: add edit button
                  return UserSpecificOneRepMaxListTile(userSpecificExercise: userSpecificExercise);
                }).toList(),
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

class UserSpecificOneRepMaxListTile extends StatefulWidget {
  final UserSpecificExerciseBus userSpecificExercise;
  const UserSpecificOneRepMaxListTile({
    super.key,
    required this.userSpecificExercise,
  });

  @override
  State<UserSpecificOneRepMaxListTile> createState() => _UserSpecificOneRepMaxListTileState();
}

class _UserSpecificOneRepMaxListTileState extends State<UserSpecificOneRepMaxListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${widget.userSpecificExercise.oneRepMax.toString()} ${getDateStringForDisplay(widget.userSpecificExercise.date)} ${getTimeStringForDisplay(widget.userSpecificExercise.date)}"),
      trailing: SizedBox(
        width: 96, // Gives enough space for two icons
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: EditUserSpecificOneRepMaxEditFields(
                      userSpecificExercise: widget.userSpecificExercise
                    )
                  )
                );
              },
              icon: const Icon(Icons.edit)
            ),
            IconButton(
              onPressed: () {
                //TODO: add delete functionality
              },
              icon: const Icon(Icons.delete)
            ),
          ],
        ),
      ),
    );
  }
}

class EditUserSpecificOneRepMaxEditFields extends StatefulWidget {
  final UserSpecificExerciseBus userSpecificExercise;
  const EditUserSpecificOneRepMaxEditFields({super.key, required this.userSpecificExercise});

  @override
  State<EditUserSpecificOneRepMaxEditFields> createState() => _EditUserSpecificOneRepMaxEditFieldsState();
}

class _EditUserSpecificOneRepMaxEditFieldsState extends State<EditUserSpecificOneRepMaxEditFields> {
  final TextEditingController oneRepMaxController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(controller: oneRepMaxController, decoration: const InputDecoration(labelText: 'One Rep Max'), keyboardType: TextInputType.number, onChanged: (value) => widget.userSpecificExercise.oneRepMax = double.parse(value),),
        //TODO: add date picker
        ElevatedButton(onPressed: () {}, child: const Text("Save")),
      ],
    );
  }
}
