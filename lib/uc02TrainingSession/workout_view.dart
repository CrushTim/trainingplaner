import 'package:flutter/material.dart';
import 'package:trainingplaner/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/uc03TrainingExcercise/training_excercise_row.dart';
import 'package:trainingplaner/functions/functions_trainingsplaner.dart';

///
/// This class represents the view of a workout.
/// It represents the current Trainingsession with all excercises and sets.
/// It is Used in the HomePage to display the current workout.
/// It makes the user able to add new excercises to the workout and to finish the workout in the Excercise diary.
///
class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  TextEditingController workoutLengthController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  DateTime _startDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
            Center(
              child: Text(
                "Workout1 - name - emphasis",
                style: TextStyle(
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: workoutLengthController,
              decoration: const InputDecoration(
                labelText: "Workout Length in minutes",
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                workoutLengthController.text = value;
              },
            ),
            //TODO: make date time Picker

            DatePickerSheer(
              initialDateTime: _startDate,
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _startDate = newDateTime;
                });
              },
              dateController: _startDateController,
            ),
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
