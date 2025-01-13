import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/editFields/training_cycle_edit_fields.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_exercise_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/cycle_planning_view.dart';
import 'package:trainingplaner/frontend/uc05Overview/overview_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class TrainingCycleListTileController {
  final TrainingCycleProvider trainingCycleProvider;
  final bool planningMode;

  TrainingCycleListTileController(this.trainingCycleProvider, this.planningMode);

  /// Opens the planning view or edit view based on planning mode
  /// @param context: The build context
  /// @param cycle: The training cycle to edit/plan
  /// @return: void
  void onTileTap(BuildContext context, TrainingCycleBus cycle) {
    if (planningMode) {
      _openPlanningView(context, cycle);
    } else {
      _openEditView(context, cycle);
    }
  }

  /// Opens the edit view for a training cycle
  /// @param context: The build context
  /// @param cycle: The training cycle to edit
  /// @return: void
  void openEditView(BuildContext context, TrainingCycleBus cycle) {
    trainingCycleProvider.setSelectedBusinessClass(cycle);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: trainingCycleProvider,
          child: const TrainingCycleEditFields(),
        ),
      ),
    );
  }

  /// Deletes a training cycle
  /// @param cycle: The training cycle to delete
  /// @param scaffoldMessengerState: The scaffold messenger state
  /// @return: void
  void deleteCycle(TrainingCycleBus cycle, ScaffoldMessengerState scaffoldMessengerState) {
    trainingCycleProvider.deleteBusinessClass(cycle, scaffoldMessengerState);
    trainingCycleProvider.resetSelectedBusinessClass();
  }

  /// Opens the planning view for a training cycle
  /// @param context: The build context
  /// @param cycle: The training cycle to plan
  /// @return: void
  void _openPlanningView(BuildContext context, TrainingCycleBus cycle) {
    PlanningProvider planningProvider = PlanningProvider(exerciseProvider: TrainingExerciseProvider());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
                  ChangeNotifierProvider.value(value: trainingCycleProvider),
                  ChangeNotifierProvider(
                    create: (_) {
                      var sessionProvider = TrainingSessionProvider(exerciseProvider: TrainingExerciseProvider());
                      sessionProvider.allCycles = [cycle];
                      return sessionProvider;
                    }
                  ),
                  ChangeNotifierProvider(
                    create: (_) => OverviewProvider(),
                  ),
                  ChangeNotifierProvider.value(value: planningProvider),
                  ChangeNotifierProvider.value(value: TrainingExerciseProvider()),
                ],
          child: CyclePlanningView(cycle: cycle),
        ),
      ),
    );
  }

  /// Opens the edit view for a training cycle
  /// @param context: The build context
  /// @param cycle: The training cycle to edit
  /// @return: void
  void _openEditView(BuildContext context, TrainingCycleBus cycle) {
    trainingCycleProvider.setSelectedBusinessClass(cycle);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: trainingCycleProvider,
          child: const TrainingCycleEditFields(),
        ),
      ),
    );
  }
} 