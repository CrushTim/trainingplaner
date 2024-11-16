import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc05Overview/overview_provider.dart';

class DayFieldCalendar extends StatelessWidget {
  final DateTime date;
  final List workouts;
  
  const DayFieldCalendar({
    super.key,
    required this.workouts,
    required this.date,
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
    List<Widget> sessionRows = overviewProvider.buildSessionRows(
      context,
      plannedSessions,
      unpaired,
      trainingSessionProvider
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
      child: Column(
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
        ],
      ),
    );
  }
}