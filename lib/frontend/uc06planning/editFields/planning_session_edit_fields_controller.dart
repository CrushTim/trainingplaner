import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/uc06planning/exercise/addPlanningExerciseTile/add_planning_exercise_edit_fields.dart';
import 'package:trainingplaner/frontend/uc06planning/exercise/addPlanningExerciseTile/add_planning_exercise_tile.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class PlanningSessionEditFieldsController {
  final PlanningProvider provider;
  
  final TextEditingController sessionNameController;
  final TextEditingController sessionDescriptionController;
  final TextEditingController sessionEmphasisController;
  final TextEditingController sessionLengthController;

  PlanningSessionEditFieldsController(this.provider)
      : sessionNameController = provider.sessionNameController,
        sessionDescriptionController = provider.sessionDescriptionController,
        sessionEmphasisController = provider.sessionEmphasisController,
        sessionLengthController = provider.sessionLengthController {
    initState();
  }

  void initState() {
    final target = provider.getSelectedBusinessClass;
    if (target != null) {
      sessionNameController.text = target.trainingSessionName;
      sessionDescriptionController.text = target.trainingSessionDescription;
      sessionEmphasisController.text = target.trainingSessionEmphasis.join(', ');
      sessionLengthController.text = target.trainingSessionLength.toString();
      provider.selectedSessionDate = target.trainingSessionStartDate;
    } else {
      sessionNameController.clear();
      sessionDescriptionController.clear();
      sessionEmphasisController.clear();
      sessionLengthController.text = "60";
      provider.businessClassForAdd.trainingSessionStartDate = provider.selectedSessionDate;
    }
  }

  void handleFieldChange(String field, String value) {
    final target = provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
    switch (field) {
      case 'name':
        target.trainingSessionName = value;
        break;
      case 'description':
        target.trainingSessionDescription = value;
        break;
      case 'emphasis':
        target.trainingSessionEmphasis = value.split(',').map((e) => e.trim()).toList();
        break;
      case 'length':
        target.trainingSessionLength = int.tryParse(value) ?? 60;
        break;
    }
  }

  Future<void> openAddExerciseDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const Dialog(
        child: AddPlanningExerciseEditFields(),
      ),
    ).then((value) {
      if (value != null) {
        provider.exercisesToDeleteIfSessionAddIsCancelled.add(value);
      }
      provider.exerciseProvider.resetBusinessClassForAdd();
    });
  }

  List<Widget> buildExerciseList(BuildContext context) {
    final exercises = provider.getSelectedBusinessClass?.trainingSessionExercises ?? 
                     provider.businessClassForAdd.trainingSessionExercises;
    
    return exercises.map((exercise) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: AddPlanningExerciseTile(
        exercise: exercise,
        onUpdate: (updatedExercise) {
          ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
          provider.exerciseProvider.updateBusinessClass(updatedExercise, scaffoldMessenger);
          if (provider.getSelectedBusinessClass != null) {
            provider.updateSelectedBusinessClass(scaffoldMessenger, notify: false);
          }
        },
        onDelete: (exercise) {
          if (provider.getSelectedBusinessClass != null) {
            provider.getSelectedBusinessClass!.trainingSessionExercises.remove(exercise);
            provider.getSelectedBusinessClass!.trainingSessionExcercisesIds.remove(exercise.trainingExerciseID);
          } else {
            provider.businessClassForAdd.trainingSessionExercises.remove(exercise);
            provider.businessClassForAdd.trainingSessionExcercisesIds.remove(exercise.trainingExerciseID);
            provider.exercisesToDeleteIfSessionAddIsCancelled.remove(exercise);
          }
        },
      ),
    )).toList();
  }

  void dispose() {
    // Controllers are owned by the provider, so we don't dispose them here
  }
} 