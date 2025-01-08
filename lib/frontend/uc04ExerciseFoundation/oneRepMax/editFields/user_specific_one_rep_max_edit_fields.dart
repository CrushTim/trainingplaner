import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_time_picker.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/oneRepMax/editFields/user_specific_one_rep_max_controller.dart';

class UserSpecificOneRepMaxEditFields extends StatefulWidget {
  final UserSpecificExerciseBus userSpecificExercise;
  const UserSpecificOneRepMaxEditFields({super.key, required this.userSpecificExercise});

  @override
  State<UserSpecificOneRepMaxEditFields> createState() => _UserSpecificOneRepMaxEditFieldsState();
}

class _UserSpecificOneRepMaxEditFieldsState extends State<UserSpecificOneRepMaxEditFields> {
  late UserSpecificOneRepMaxController controller;

  @override
  void initState() {
    super.initState();
    controller = UserSpecificOneRepMaxController(
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller.oneRepMaxController,
          decoration: const InputDecoration(labelText: 'One Rep Max'),
          keyboardType: TextInputType.number,
          onChanged: (value) => controller.handleTextFieldChange('oneRepMax', value),
        ),
        DateTimePickerSheer(
          onDateTimeChanged: (dateTime) {
            setState(() {
              controller.onDateTimeChanged(dateTime);
            });
          },
          initialDateTime: controller.initialDateTime,
        ),
        ElevatedButton(
          onPressed: () {
            controller.saveUserSpecificExercise(ScaffoldMessenger.of(context));
            Navigator.of(context).pop(true);
          },
          child: const Text("Save")
        ),
      ],
    );
  }
}
