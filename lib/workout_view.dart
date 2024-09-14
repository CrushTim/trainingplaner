import 'package:flutter/material.dart';
import 'package:trainingplaner/costum_widgets/training_excercise_row.dart';
import 'package:trainingplaner/functions/functions_trainingsplaner.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
            Center(
              child: Text(
                "Workout1 - name - ${getDateStringForDisplay(DateTime.now())}",
                style: TextStyle(
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              ),
            )
          ] +
          List<Widget>.generate(10, (index) {
            return TrainingExcerciseRow();
          }) +
          <Widget>[
            IconButton(
              onPressed: () {
                //TODO Add new excercise to the workout
                print("Pressed add");
              },
              icon: Icon(Icons.add),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      child: Text("Update Diary Entry"),
                      onPressed: () {
                        print("Pressed upate");
                        //TODO: implement provider update of selected workout
                      }),
                ),
                Expanded(
                  child: ElevatedButton(
                      child: Text("Finish Workout"),
                      onPressed: () {
                        print("Pressed finish");
                        //TODO: implement provider finish of selected workout (save diary entry and move selected workout to the next workout);
                      }),
                ),
              ],
            )
          ],
    );
  }
}
