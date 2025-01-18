import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/editFields/exercise_foundation_edit_fields_controller.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/oneRepMax/editFields/user_specific_one_rep_max_edit_fields.dart';

class ExerciseFoundationEditFields extends StatefulWidget {
  final bool enableAllFields; 
  const ExerciseFoundationEditFields({super.key, this.enableAllFields = false});

  @override
  State<ExerciseFoundationEditFields> createState() => _ExerciseFoundationEditFieldsState();
}

class _ExerciseFoundationEditFieldsState extends State<ExerciseFoundationEditFields> {
  late ExerciseFoundationEditFieldsController controller;

  @override
  void initState() {
    super.initState();
    controller = ExerciseFoundationEditFieldsController(
      Provider.of<ExerciseFoundationProvider>(context, listen: false)
    );
    controller.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExerciseFoundationProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.getTitleText()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                readOnly: !widget.enableAllFields,
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => controller.handleTextFieldChange('name', value),
              ),
              TextField(
                readOnly: !widget.enableAllFields,
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => controller.handleTextFieldChange('description', value),
              ),
              TextField(
                readOnly: !widget.enableAllFields,
                controller: controller.picturePathController,
                decoration: const InputDecoration(labelText: 'Picture Path'),
                onChanged: (value) => controller.handleTextFieldChange('picturePath', value),
              ),
              TextField(
                readOnly: !widget.enableAllFields,
                controller: controller.categoriesController,
                decoration: const InputDecoration(labelText: 'Categories (comma-separated)'),
                onChanged: (value) => controller.handleTextFieldChange('categories', value),
              ),
              TextField(
                  readOnly: !widget.enableAllFields,
                controller: controller.muscleGroupsController,
                decoration: const InputDecoration(labelText: 'Muscle Groups (comma-separated)'),
                onChanged: (value) => controller.handleTextFieldChange('muscleGroups', value),
              ),
              TextField(
                readOnly: !widget.enableAllFields,
                controller: controller.amountOfPeopleController,
                decoration: const InputDecoration(labelText: 'Amount of People'),
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.handleTextFieldChange('amountOfPeople', value),
              ),
              TextField(
                controller: controller.notesController,
                decoration: const InputDecoration(labelText: 'Notes (comma-separated)'),
                onChanged: (value) => controller.handleTextFieldChange('notes', value),
              ),
              controller.showUserSpecificExercises(),
              ElevatedButton(onPressed: () async {
                controller.prepareForAddOneRepMaxDialog();
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
                    controller.afterOneRepMaxDialogIsTrue();
                    setState(() {});
                  }
                  controller.resetAfterSave();
                });
              }, child: const Text("Add 1 Rep Max")),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await controller.saveExerciseFoundation(ScaffoldMessenger.of(context));
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
