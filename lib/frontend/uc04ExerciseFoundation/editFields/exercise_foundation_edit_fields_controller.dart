import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_notes.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/oneRepMax/listTile/user_specific_one_rep_max_list_tile.dart';

class ExerciseFoundationEditFieldsController {
  final ExerciseFoundationProvider provider;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController picturePathController = TextEditingController();
  final TextEditingController categoriesController = TextEditingController();
  final TextEditingController muscleGroupsController = TextEditingController();
  final TextEditingController amountOfPeopleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  ExerciseFoundationEditFieldsController(this.provider);


  /// Initialize the state of the controller
  /// Should be called when the state is initialized
  /// @return: void
  void initState() {
    if (provider.getSelectedBusinessClass != null) {
      nameController.text = provider.getSelectedBusinessClass!.exerciseFoundationName;
      descriptionController.text = provider.getSelectedBusinessClass!.exerciseFoundationDescription;
      picturePathController.text = provider.getSelectedBusinessClass!.exerciseFoundationPicturePath;
      categoriesController.text = provider.getSelectedBusinessClass!.exerciseFoundationCategories.join(', ');
      muscleGroupsController.text = provider.getSelectedBusinessClass!.exerciseFoundationMuscleGroups.join(', ');
      amountOfPeopleController.text = provider.getSelectedBusinessClass!.exerciseFoundationAmountOfPeople.toString();
      notesController.text = provider.getSelectedBusinessClass!.exerciseFoundationNotes?.exerciseFoundationNotes.join(', ') ?? "";
    } else {
      nameController.text = provider.businessClassForAdd.exerciseFoundationName;
      descriptionController.text = provider.businessClassForAdd.exerciseFoundationDescription;
      picturePathController.text = provider.businessClassForAdd.exerciseFoundationPicturePath;
      categoriesController.text = provider.businessClassForAdd.exerciseFoundationCategories.join(', ');
      muscleGroupsController.text = provider.businessClassForAdd.exerciseFoundationMuscleGroups.join(', ');
      amountOfPeopleController.text = provider.businessClassForAdd.exerciseFoundationAmountOfPeople.toString();
      notesController.text = provider.businessClassForAdd.exerciseFoundationNotes?.exerciseFoundationNotes.join(', ') ?? "";
    }
  }

  /// Handle the text field change
  /// it updates the target exercise foundation with the new value
  /// the target is the selected exercise foundation or the business class for add
  /// Should be called when the text field is changed
  /// @params field: the field that is changed
  /// @params value: the value of the field
  /// @return: void
  void handleTextFieldChange(String field, String value) {
    ExerciseFoundationBus target = provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
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
      case 'notes':
        String id = target.exerciseFoundationNotes?.exerciseFoundationNotesId ?? "";
        target.exerciseFoundationNotes = ExerciseFoundationNotesBus(
          exerciseFoundationNotesId: id,
          exerciseFoundationNotes: value.split(',').map((e) => e.trim()).toList(),
          exerciseFoundationId: target.getId()
        );
        break;
    }
  }

  /// The method that is used to either add the for add or update the selected business class
  /// it then checks if the notes are null and if they are not it updates the notes
  /// Should be called when the save button is pressed
  /// @params scaffoldMessengerState: the scaffold messenger state to show the snackbar
  /// @return: void
  Future<void> saveExerciseFoundation(ScaffoldMessengerState scaffoldMessengerState) async {
    ExerciseFoundationNotesBus? targetNotes;
    ExerciseFoundationBus target = provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
    String addId = "";
    
    if (provider.getSelectedBusinessClass != null) {
      targetNotes = provider.getSelectedBusinessClass!.exerciseFoundationNotes;
      await provider.updateBusinessClass(provider.getSelectedBusinessClass!, scaffoldMessengerState);
    } else {
      targetNotes = provider.businessClassForAdd.exerciseFoundationNotes;
      addId = await provider.addBusinessClass(provider.businessClassForAdd, scaffoldMessengerState);
    }

    if(targetNotes != null) {
      targetNotes.exerciseFoundationId = provider.getSelectedBusinessClass == null ? addId : provider.getSelectedBusinessClass!.getId();
      
      if(provider.notesMap[target.getId()] == null) {
        await provider.addExerciseFoundationNotes(targetNotes, scaffoldMessengerState);
      } else {
        await provider.updateExerciseFoundationNotes(targetNotes, scaffoldMessengerState);
      }
    }
  }

  /// Dispose the controller
  /// Should be called when the controller is disposed
  /// @return: void
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    picturePathController.dispose();
    categoriesController.dispose();
    muscleGroupsController.dispose();
    amountOfPeopleController.dispose();
    notesController.dispose();
  }

  /// Reset the controller
  /// @return: void
  void reset() {
    nameController.clear();
    descriptionController.clear();
    picturePathController.clear();
    categoriesController.clear();
    muscleGroupsController.clear();
    amountOfPeopleController.clear();
    notesController.clear();
  }

  /// Reset everything that was changed in the provider after the save button is pressed
  /// @return: void
  void resetAfterSave() {   
    reset();
    provider.initialDateTimeOneRepMax = DateTime.now();
    provider.resetUserSpecificExerciseForAdd();
    provider.resetSelectedUserSpecificExercise();
  }

  /// Add the user specific exercise bus for add to the user specific exercise list
  /// @return: void
  void afterOneRepMaxDialogIsTrue() {
    provider.userSpecificExercise.add(provider.userSpecificExerciseBusForAdd);
  }

  /// Get the title text for the dialog
  /// @return: String
  String getTitleText() {
    return provider.getSelectedBusinessClass == null ? "Add Exercise Foundation" : "Edit Exercise Foundation";
  }

  /// Prepare the user specific exercise bus for add for the one rep max dialog
  /// should be called before the one rep max dialog is opened
  /// @return: void
  void prepareForAddOneRepMaxDialog() {
    provider.userSpecificExerciseBusForAdd.foundationId = provider.getSelectedBusinessClass!.getId();
    provider.initialDateTimeOneRepMax = provider.userSpecificExerciseBusForAdd.date;
  }

  /// shows the userspecific exercises depending on if the list is not empty
  /// @reutrn: Widget
  Widget showUserSpecificExercises() {
    return provider.userSpecificExercise.isEmpty ? const Text("No 1 Rep max data available") : Column(
      children: provider.userSpecificExercise.map((userSpecificExercise) {
        return UserSpecificOneRepMaxListTile(userSpecificExercise: userSpecificExercise);
      }).toList(),
    );
  } 
} 