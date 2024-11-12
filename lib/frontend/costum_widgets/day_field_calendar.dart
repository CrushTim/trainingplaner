import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/workout_view.dart';
import 'package:collection/collection.dart';

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
                fontWeight: FontWeight.bold),
          ),
          ...List.generate(workouts.length, (index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: GestureDetector(
                onTap: () async {
                  if(workouts[index].isPlanned == true){
                    trainingSessionProvider.setActualAndPlannedSession(workouts[index], trainingSessionProvider.plannedToActualSessions.entries.firstWhere((entry) => entry.key.trainingSessionId == workouts[index].trainingSessionId, orElse: () => MapEntry(workouts[index], null)).value);
                  } else {
                      trainingSessionProvider.setActualAndPlannedSession(trainingSessionProvider.plannedToActualSessions.keys.firstWhereOrNull(
                      (key) => key.trainingSessionId == workouts[index].plannedSessionId,), workouts[index]);
                  }
                  await Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                        value: trainingSessionProvider, 
                        child: WorkoutView()
                      )
                    )
                  );
                  trainingSessionProvider.resetAllListsAndBusinessClasses();
                }, 
                child: Text(workouts.elementAt(index).trainingSessionName)
              )
            );
          }),
        ],
      ),
    );
  }
}
