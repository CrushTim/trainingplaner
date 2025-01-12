import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';

class TrainingExerciseListTileController {

  TrainingExerciseListTileController({this.plannedExercise, this.actualExercise});


  ///if the list tile is expanded
  ///if its expanded, the weightsreps row are visible and editable
  bool isExpanded = false;

  ///the actual exercise
  ///this is where the changes are saved and the exercise is updated
  TrainingExerciseBus? actualExercise;

  ///the planned exercise
  TrainingExerciseBus? plannedExercise;


  void toggleExpanded() {
    isExpanded = !isExpanded;
  }

  //returns a different arrow icon depending on the isExpanded state
  IconData getArrowIcon() {
    return isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down;
  }

  void updateRepsAndWeight(int index, int reps, double weight) {
    if (actualExercise == null) return;
    
    actualExercise!.exerciseReps[index] = reps;
    actualExercise!.exerciseWeights[index] = weight;
  }

  void deleteRepsAndWeight(int index) {
    if (actualExercise == null) return;
    
    actualExercise!.exerciseReps.removeAt(index);
    actualExercise!.exerciseWeights.removeAt(index);
  }

  void addNewSet() {
    if (actualExercise == null) return;

    if (actualExercise!.exerciseWeights.isNotEmpty) {
      // Copy values from the last set
      actualExercise!.exerciseWeights.add(
        actualExercise!.exerciseWeights[actualExercise!.exerciseWeights.length - 1]
      );
      actualExercise!.exerciseReps.add(
        actualExercise!.exerciseReps[actualExercise!.exerciseReps.length - 1]
      );
    } else {
      // Add default values for first set
      actualExercise!.exerciseWeights.add(0);
      actualExercise!.exerciseReps.add(0);
    }
  }

  ///sets the actual exercise
  ///if the actual exercise is null, it creates a new one
  void setActualExercise() {
    actualExercise ??= plannedExercise!.createActualExercise();
  }

  ///returns the exercise display text
  ///this is used to display the exercise name in the list tile
  ///@return the exercise display text
  String getExerciseDisplayText() {
    return plannedExercise?.exerciseName ?? actualExercise!.exerciseName;
  }


  ///returns the exercise foundation id
  ///this is used to display the foundation id in the list tile
  ///@return the exercise foundation id
  String getExerciseFoundationID() {
    return plannedExercise?.exerciseFoundationID ?? actualExercise!.exerciseFoundationID;
  }

  ///returns a list of texts for the planned exercise
  ///this is used to display the planned exercise in the list tile
  ///the texts are the reps and weights for the planned exercise
  ///@return a list of texts
  List<Widget> getAllTextsForPlannedExercise() {
    List<Widget> texts = [];
    for(int i = 0; i < plannedExercise!.exerciseReps.length; i++) {
      texts.add(Text("${plannedExercise!.exerciseReps[i]} x ${plannedExercise!.exerciseWeights[i]}kg"));
    }
    return texts;
  }

  ///returns a list of texts for the actual exercise
  ///this is used to display the actual exercise in the list tile
  ///the texts are the reps and weights for the actual exercise
  ///@return a list of texts
  List<Widget> getAllTextsForActualExercise() {
    List<Widget> texts = [];
    for(int i = 0; i < actualExercise!.exerciseReps.length; i++) {
      texts.add(Text("${actualExercise!.exerciseReps[i]} x ${actualExercise!.exerciseWeights[i]}kg"));
    }
    return texts;
  }

  bool hasExerciseSets() {
    return actualExercise != null && actualExercise!.exerciseReps.isNotEmpty;
  }

  int getNumberOfSets() {
    return actualExercise?.exerciseReps.length ?? 0;
  }

} 