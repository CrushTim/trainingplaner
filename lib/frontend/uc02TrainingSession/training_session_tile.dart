import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';

class SessionTile extends StatelessWidget {
  final TrainingSessionBus session;
  final bool isPlanned;
  final VoidCallback onTap;

  const SessionTile({
    super.key,
    required this.session,
    required this.isPlanned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: isPlanned ? Colors.orange[100] : Colors.green[100],
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.trainingSessionName, 
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text(getDateStringForDisplay(session.trainingSessionStartDate)),
                Text(getTimeStringForDisplay(session.trainingSessionStartDate)),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.trainingSessionDescription),
            Text(session.trainingSessionEmphasis.join(', ')),
            Text(session.trainingSessionExercises
                .map((e) => e.exerciseName)
                .join(', ')),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}