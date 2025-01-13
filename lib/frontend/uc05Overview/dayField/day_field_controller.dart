
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/ParentClasses/day_field_base_controller.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/workout/view/workout_view.dart';

class DayFieldController extends DayFieldBaseController {

  DayFieldController(this.trainingSessionProvider);
  
  final TrainingSessionProvider trainingSessionProvider;


  List<Widget> buildSessionRows(
    BuildContext context,
    List workouts,
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
              child: _buildSessionTile(
                context,
                entry.key,
                entry.value,
                Colors.green,
              ),
            ),
            if (entry.value != null)
              Expanded(
                child: _buildSessionTile(
                  context,
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
              child: _buildSessionTile(
                context,
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

  Widget _buildSessionTile(
    BuildContext context,
    dynamic plannedSession,
    dynamic actualSession,
    Color color,
  ) {
    return GestureDetector(
      onTap: () async {
        trainingSessionProvider.setActualAndPlannedSession(
          plannedSession,
          actualSession
        );
        await Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: trainingSessionProvider, 
              child: const WorkoutView()
            )
          )
        );
        trainingSessionProvider.resetAllListsAndBusinessClasses();
      },
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
