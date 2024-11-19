import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc05Overview/overview_provider.dart';

class PlanningDayFieldCalendar extends StatelessWidget {
  final DateTime date;
  final List workouts;
  final VoidCallback onAddPressed;
  
  const PlanningDayFieldCalendar({
    super.key,
    required this.workouts,
    required this.date,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    TrainingSessionProvider trainingSessionProvider = Provider.of<TrainingSessionProvider>(context);
    OverviewProvider overviewProvider = Provider.of<OverviewProvider>(context);

    // Get planned and unplanned sessions
    Map<dynamic, dynamic> plannedSessions = overviewProvider.separatePlannedAndUnplannedSessions(workouts);
    List unplannedSessions = workouts.where((w) => !w.isPlanned).toList();
    List unpaired = overviewProvider.getUnpairedSessions(unplannedSessions, plannedSessions);

    // Build session rows
    List<Widget> sessionRows = overviewProvider.buildPlanningSessionRows(
      context,
      plannedSessions,
      unpaired,
      trainingSessionProvider,
      date,
    );

    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        shape: BoxShape.rectangle,
        color: Colors.red,
      ),
      child: DragTarget<Map<String, dynamic>>(
        onAcceptWithDetails: (details) {
          final data = details.data;
          print('Session dropped on date: $date');
          print('Drop position: ${details.offset}');
          print('Planned Session: ${data['plannedSession']?.trainingSessionName}');
          print('Actual Session: ${data['actualSession']?.trainingSessionName}');
          // TODO: Implement the logic to update the session date
        },
        builder: (context, candidateData, rejectedData) {
          return Column(
            children: [
              Text(
                "${date.day}.${date.month}",
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              ...sessionRows,
              IconButton(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add),
              ),
            ],
          );
        },
      ),
    );
  }
} 