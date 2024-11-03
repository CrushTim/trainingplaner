import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/frontend/date_time_picker.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';

class UserSpecificOneRepMaxEditFields extends StatefulWidget {
  final UserSpecificExerciseBus userSpecificExercise;
  const UserSpecificOneRepMaxEditFields({super.key, required this.userSpecificExercise});

  @override
  State<UserSpecificOneRepMaxEditFields> createState() => _UserSpecificOneRepMaxEditFieldsState();
}

class _UserSpecificOneRepMaxEditFieldsState extends State<UserSpecificOneRepMaxEditFields> {

  @override
  void initState() {
    super.initState();
    ExerciseFoundationProvider provider = Provider.of<ExerciseFoundationProvider>(context, listen: false);
    provider.initStateUserSpecificExercise();
  }

 



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExerciseFoundationProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(controller: provider.oneRepMaxController, decoration: const InputDecoration(labelText: 'One Rep Max'), keyboardType: TextInputType.number, onChanged: (value) => provider.handleTextFieldChangeUserSpecificExercise('oneRepMax', value),),
        DateTimePickerSheer(onDateTimeChanged: (dateTime) {
          setState(() {
            provider.onDateTimeChangedUserSpecificExercise(dateTime);
          });
        }, initialDateTime: provider.initialDateTime,),
        ElevatedButton(onPressed: () {
          provider.saveUserSpecificExercise(ScaffoldMessenger.of(context));
          provider.resetUserSpecificExerciseForAdd();
          provider.resetSelectedUserSpecificExercise();
          Navigator.pop(context);
        }, child: const Text("Save")),
      ],
    );
  }
}
