
import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/ParentClasses/day_field_base_controller.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class PlanningDayFieldController extends DayFieldBaseController {
  final TrainingSessionProvider trainingSessionProvider;

  PlanningDayFieldController(this.trainingSessionProvider);

   List<Widget> buildPlanningSessionRows(
    BuildContext context,
    List workouts,
    DateTime date,
  ) {
    Map<dynamic, dynamic> plannedSessions = separatePlannedAndUnplannedSessions(workouts);
    List unpaired = getUnpairedSessions(getUnplannedSessions(workouts), plannedSessions);
    List<Widget> sessionRows = [];

    // Add planned-unplanned pairs
    for (var entry in plannedSessions.entries) {
      sessionRows.add(
        Row(
          children: [
            Expanded(
              child: _buildPlanningSessionTile(
                entry.key,
                entry.value,
                Colors.green,
              ),
            ),
            if (entry.value != null)
              Expanded(
                child: _buildPlanningSessionTile(
                  entry.key,
                  entry.value,
                  Colors.grey,
                ),
              ),
          ],
        )
      );
    }

    // Add unpaired unplanned sessions
    for (var session in unpaired) {
      sessionRows.add(
        Row(
          children: [
            Expanded(
              child: _buildPlanningSessionTile(
                null,
                session,
                Colors.grey,
              ),
            ),
          ],
        )
      );
    }

    return sessionRows;
  }

  Widget _buildPlanningSessionTile(
      dynamic plannedSession,
      dynamic actualSession,
      Color color,
    ) {
      return Draggable<Map<String, dynamic>>(
        data: {
          'plannedSession': plannedSession,
          'actualSession': actualSession,
        },
        feedback: Material(
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: color.withOpacity(0.7),
            ),
            child: Text(
              (actualSession ?? plannedSession).trainingSessionName,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        childWhenDragging: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.grey.withOpacity(0.3),
          ),
          child: Text(
            (actualSession ?? plannedSession).trainingSessionName,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: color,
          ),
          child: Text(
            (actualSession ?? plannedSession).trainingSessionName
          ),
        ),
      );
    }
}