import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class CycleEditColumn extends StatelessWidget {
  final List<dynamic> weekSessions;

  const CycleEditColumn({
    super.key,
    required this.weekSessions,
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
            onPressed: () {
              // TODO: Implement target 1RM functionality
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
                  planningProvider.storeWeekSessions(weekSessions.cast<TrainingSessionBus>());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Week copied')),
                  );
                },
              ),
              const PopupMenuItem(
                value: 'option2',
                child: Text('To Implement 2'),
              ),
              const PopupMenuItem(
                value: 'option3',
                child: Text('To Implement 3'),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 