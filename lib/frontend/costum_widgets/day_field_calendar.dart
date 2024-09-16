import 'package:flutter/material.dart';

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
    return Container(
      height: 100,
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
            ] +
            //TODO make workouts selectable and open in workout view
            List.generate(workouts.length, (index) {
              return Text(workouts[index]);
            }),
      ),
    );
  }
}
