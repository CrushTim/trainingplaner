import 'package:flutter/material.dart';

class RepsWeightsRowController {
  final TextEditingController repsController;
  final TextEditingController weightController;
  final Function(int reps, double weight) onUpdate;
  bool isFailure = false;

  RepsWeightsRowController({
    required int initialReps,
    required double initialWeight,
    required this.onUpdate,
  }) : repsController = TextEditingController(text: initialReps.toString()),
       weightController = TextEditingController(text: initialWeight.toString());

  void dispose() {
    repsController.dispose();
    weightController.dispose();
  }

  void handleRepsChange(String value) {
    int? reps = int.tryParse(value);
    if (reps != null) {
      double currentWeight = double.tryParse(weightController.text) ?? 0;
      onUpdate(reps, currentWeight);
    }
  }

  void handleWeightChange(String value) {
    double? weight = double.tryParse(value);
    if (weight != null) {
      int currentReps = int.tryParse(repsController.text) ?? 0;
      onUpdate(currentReps, weight);
    }
  }

  void toggleFailure() {
    isFailure = !isFailure;
  }
}