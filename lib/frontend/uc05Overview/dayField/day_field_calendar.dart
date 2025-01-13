import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc05Overview/dayField/day_field_controller.dart';

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
    DayFieldController controller = DayFieldController(Provider.of<TrainingSessionProvider>(context));
    // Build session rows

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
          ...controller.buildSessionRows(
            context,
            workouts,
          ),
        ],
      ),
    );
  }
}