
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';

class ExerciseFoundationOverviewView extends StatefulWidget {
  const ExerciseFoundationOverviewView({super.key});

  @override
  State<ExerciseFoundationOverviewView> createState() => _ExerciseFoundationOverviewViewState();
}

class _ExerciseFoundationOverviewViewState extends State<ExerciseFoundationOverviewView> {
  @override
  Widget build(BuildContext context) {
    ExerciseFoundationProvider exerciseFoundationProvider = Provider.of<ExerciseFoundationProvider>(context);
    return Column(
      children: [
        exerciseFoundationProvider.getAllExerciseFoundationsWithUserLinks(),
        ElevatedButton(onPressed: () {
          exerciseFoundationProvider.businessClassForAdd.exerciseFoundationName = "New Exercise Foundation";
          exerciseFoundationProvider.businessClassForAdd.exerciseFoundationDescription = "New Exercise Foundation Description";
          exerciseFoundationProvider.businessClassForAdd.exerciseFoundationPicturePath = "New Exercise Foundation Picture Path";
          exerciseFoundationProvider.businessClassForAdd.exerciseFoundationCategories = ["New Exercise Foundation Category"];
          exerciseFoundationProvider.businessClassForAdd.exerciseFoundationMuscleGroups = ["New Exercise Foundation Muscle Group"];
          exerciseFoundationProvider.businessClassForAdd.exerciseFoundationAmountOfPeople = 1;

          exerciseFoundationProvider.addForAddBusinessClass(ScaffoldMessenger.of(context));
        }, child: const Text("Add Exercise Foundation")),
      ],
    );
  }
}
