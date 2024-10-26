import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/business/reports/excercise_foundation_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_list_tile.dart';

class ExerciseFoundationProvider extends TrainingsplanerProvider<ExerciseFoundationBus, ExerciseFoundationBusReport> {
  ExerciseFoundationProvider() : super(
    businessClassForAdd: ExerciseFoundationBus(
      exerciseFoundationId: "",
      exerciseFoundationName: "",
      exerciseFoundationDescription: "",
      exerciseFoundationPicturePath: "",
      exerciseFoundationCategories: [],
      exerciseFoundationMuscleGroups: [],
      exerciseFoundationAmountOfPeople: 1,
    ),
    reportTaskVar: ExerciseFoundationBusReport(),
  );

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController picturePathController = TextEditingController();
  final TextEditingController categoriesController = TextEditingController();
  final TextEditingController muscleGroupsController = TextEditingController();
  final TextEditingController amountOfPeopleController = TextEditingController();

  @override
  void initState() {
    if (getSelectedBusinessClass != null) {
      nameController.text = getSelectedBusinessClass!.exerciseFoundationName;
      descriptionController.text = getSelectedBusinessClass!.exerciseFoundationDescription;
      picturePathController.text = getSelectedBusinessClass!.exerciseFoundationPicturePath;
      categoriesController.text = getSelectedBusinessClass!.exerciseFoundationCategories.join(', ');
      muscleGroupsController.text = getSelectedBusinessClass!.exerciseFoundationMuscleGroups.join(', ');
      amountOfPeopleController.text = getSelectedBusinessClass!.exerciseFoundationAmountOfPeople.toString();
    } else {
      nameController.text = businessClassForAdd.exerciseFoundationName;
      descriptionController.text = businessClassForAdd.exerciseFoundationDescription;
      picturePathController.text = businessClassForAdd.exerciseFoundationPicturePath;
      categoriesController.text = businessClassForAdd.exerciseFoundationCategories.join(', ');
      muscleGroupsController.text = businessClassForAdd.exerciseFoundationMuscleGroups.join(', ');
      amountOfPeopleController.text = businessClassForAdd.exerciseFoundationAmountOfPeople.toString();
    }
  }

  void handleTextFieldChange(String field, String value) {
    ExerciseFoundationBus target = getSelectedBusinessClass ?? businessClassForAdd;
    switch (field) {
      case 'name':
        target.exerciseFoundationName = value;
        break;
      case 'description':
        target.exerciseFoundationDescription = value;
        break;
      case 'picturePath':
        target.exerciseFoundationPicturePath = value;
        break;
      case 'categories':
        target.exerciseFoundationCategories = value.split(',').map((e) => e.trim()).toList();
        break;
      case 'muscleGroups':
        target.exerciseFoundationMuscleGroups = value.split(',').map((e) => e.trim()).toList();
        break;
      case 'amountOfPeople':
        target.exerciseFoundationAmountOfPeople = int.tryParse(value) ?? 1;
        break;
    }
    notifyListeners();
  }

  Future<void> saveExerciseFoundation(ScaffoldMessengerState scaffoldMessengerState) async {
    if (getSelectedBusinessClass != null) {
      await updateBusinessClass(getSelectedBusinessClass!, scaffoldMessengerState);
    } else {
      await addBusinessClass(businessClassForAdd, scaffoldMessengerState);
    }
  }

  // /////////////////////////////////////////////////////////////////////
  //                         View Methods
  // /////////////////////////////////////////////////////////////////////

  StreamBuilder2 getAllExerciseFoundationsWithUserLinks() {
    return StreamBuilder2(
      streams: StreamTuple2(reportTaskVar.getAll(), ExerciseFoundationBusReport().getAll()),
      builder: (context, snapshots) {
        if (snapshots.snapshot1.connectionState == ConnectionState.waiting || snapshots.snapshot2.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshots.snapshot1.hasError || snapshots.snapshot2.hasError) {
          return Text(snapshots.snapshot1.error.toString() + snapshots.snapshot2.error.toString());
        } else {
          return Column(
            children: snapshots.snapshot1.data!.map((exerciseFoundation) {
              return ExerciseFoundationListTile(exerciseFoundation: exerciseFoundation);
            }).toList().cast<Widget>(),
          );
        }
      },
    );
  }
}
