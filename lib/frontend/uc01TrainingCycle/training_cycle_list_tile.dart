import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_edit_fields.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_exercise_provider.dart';
import 'package:trainingplaner/frontend/uc05Overview/cycle_planning_view.dart';
import 'package:trainingplaner/frontend/uc05Overview/overview_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class TrainingCycleListTile extends StatefulWidget {
  final TrainingCycleBus trainingCycleBus;
  final bool planningMode;
  
  const TrainingCycleListTile({
    super.key,
    required this.trainingCycleBus,
    this.planningMode = false,
  });

  @override
  State<TrainingCycleListTile> createState() => _TrainingCycleListTileState();
}

class _TrainingCycleListTileState extends State<TrainingCycleListTile> {
  @override
  Widget build(BuildContext context) {
    TrainingCycleProvider trainingCycleProvider = Provider.of<TrainingCycleProvider>(context);
    PlanningProvider planningProvider = Provider.of<PlanningProvider>(context);
   return GestureDetector(
      onTap: () {
        if (widget.planningMode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(value: trainingCycleProvider),
                  ChangeNotifierProvider(
                    create: (_) {
                      var sessionProvider = TrainingSessionProvider(exerciseProvider: TrainingExerciseProvider());
                      sessionProvider.allCycles = [widget.trainingCycleBus];
                      return sessionProvider;
                    }
                  ),
                  ChangeNotifierProvider(
                    create: (_) => OverviewProvider(),
                  ),
                  ChangeNotifierProvider.value(value: planningProvider),
                  ChangeNotifierProvider.value(value: TrainingExerciseProvider()),
                ],
                child: CyclePlanningView(cycle: widget.trainingCycleBus),
              ),
            ),
          );
        } else {
          trainingCycleProvider.setSelectedBusinessClass(widget.trainingCycleBus);
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
      },
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                shape: BoxShape.rectangle,
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(widget.trainingCycleBus.cycleName, style: Theme.of(context).textTheme.titleMedium),
                  Text(widget.trainingCycleBus.description),
                  Text(widget.trainingCycleBus.emphasis.join(', ')),
                  Text(widget.trainingCycleBus.beginDate.toString()),
                  Text(widget.trainingCycleBus.endDate.toString()),
                  if (widget.trainingCycleBus.parent != null) Text(widget.trainingCycleBus.parent!),
                ],
              ),
            ),
          ),
        
        Flexible(
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              trainingCycleProvider.setSelectedBusinessClass(widget.trainingCycleBus);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(value: trainingCycleProvider, child: const TrainingCycleEditFields())));
            },
          ),
        ),
        Flexible(
          child: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              trainingCycleProvider.deleteBusinessClass(widget.trainingCycleBus, ScaffoldMessenger.of(context));
              trainingCycleProvider.resetSelectedBusinessClass();
              
            },
          ),
        ),
        ],
      ),
    );
  }
}


