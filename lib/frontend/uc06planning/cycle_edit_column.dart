import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class CycleEditColumn extends StatelessWidget {
  final List<dynamic> weekSessions;
  final int copiedWeek;
  const CycleEditColumn({
    super.key,
    required this.weekSessions,
    required this.copiedWeek,
  });

  @override
  Widget build(BuildContext context) {
    final planningProvider = Provider.of<PlanningProvider>(context);
    
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        shape: BoxShape.rectangle,
        color: Colors.grey[300],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.fitness_center),
            tooltip: 'Target 1RM',
            onPressed: () async {
              final TextEditingController percentageController = TextEditingController();
              final TextEditingController setsController = TextEditingController();
              final TextEditingController repsController = TextEditingController();
              
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Adjust Training Parameters'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: percentageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Percentage Change (+/-)',
                            hintText: 'e.g., 5 or -5',
                          ),
                        ),
                        TextField(
                          controller: setsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Set Adjustment (+/-)',
                            hintText: 'e.g., 1 or -1',
                          ),
                        ),
                        TextField(
                          controller: repsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Reps Adjustment (+/-)',
                            hintText: 'e.g., 2 or -2',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          int percentageChange = int.tryParse(percentageController.text) ?? 0;
                          int setChange = int.tryParse(setsController.text) ?? 0;
                          int repChange = int.tryParse(repsController.text) ?? 0;
                          
                          planningProvider.adjustWeekExercisesParameters(
                            weekSessions.cast<TrainingSessionBus>(),
                            percentageChange,
                            setChange,
                            repChange,
                            ScaffoldMessenger.of(context),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward),
            tooltip: 'Deload',
            onPressed: () {
              // TODO: Implement deload functionality
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'copyWeek',
                child: const Text('Copy Week'),
                onTap: () {
                  planningProvider.storeWeekSessions(weekSessions.cast<TrainingSessionBus>(), copiedWeek);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Week copied')),
                  );
                },
              ),
              PopupMenuItem(
                value: 'insertWeek',
                enabled: planningProvider.copiedSessions.isNotEmpty,
                child: const Text(
                  'Insert Week',
                  
                ),
                onTap: () {
                  planningProvider.insertWeekSessions(
                    copiedWeek,
                    ScaffoldMessenger.of(context),
                  );
                  planningProvider.copiedSessions.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
} 