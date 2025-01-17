import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/planningWeekColumn/planning_week_edit_column_controller.dart';

class PlanningWeekEditColumn extends StatefulWidget {
  final List<dynamic> weekSessions;
  final int copiedWeek;
  
  const PlanningWeekEditColumn({
    super.key,
    required this.weekSessions,
    required this.copiedWeek,
  });

  @override
  State<PlanningWeekEditColumn> createState() => _PlanningWeekEditColumnState();
}

class _PlanningWeekEditColumnState extends State<PlanningWeekEditColumn> {
  late PlanningWeekEditColumnController controller;

  @override
  void initState() {
    super.initState();
    controller = PlanningWeekEditColumnController(
      planningProvider: Provider.of<PlanningProvider>(context, listen: false),
      weekSessions: widget.weekSessions,
      copiedWeek: widget.copiedWeek,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Adjust Training Parameters'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: controller.percentageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Percentage Change (+/-)',
                            hintText: 'e.g., 5 or -5',
                          ),
                        ),
                        TextField(
                          controller: controller.setsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Set Adjustment (+/-)',
                            hintText: 'e.g., 1 or -1',
                          ),
                        ),
                        TextField(
                          controller: controller.repsController,
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
                          controller.handleParameterAdjustment(context);
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
            onPressed: () => controller.handleDeload(context),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'copyWeek',
                child: const Text('Copy Week'),
                onTap: () => controller.handleCopyWeek(context),
              ),
              PopupMenuItem(
                value: 'insertWeek',
                enabled: controller.canInsertWeek,
                child: const Text('Insert Week'),
                onTap: () => controller.handleInsertWeek(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 