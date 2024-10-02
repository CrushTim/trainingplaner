import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

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
  final TextEditingController workoutLengthController = TextEditingController();
  final TextEditingController workoutNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController sessionDescriptionController =
      TextEditingController();
  final TextEditingController sessionEmphasisController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    startDateController.text = DateTime.now().toString();
    workoutLengthController.text = "60";
    workoutNameController.text = "Workout1 - name - emphasis";
  }

  @override
  Widget build(BuildContext context) {
    TrainingSessionProvider sessionProvider =
        Provider.of<TrainingSessionProvider>(context);
    return ListView(
      children:
          <Widget>[sessionProvider.getCurrentTrainingSessionStreamBuilder()] +
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
                            sessionProvider.updateSessionInDatabase(
                                sessionProvider.getSelectedBusinessClass,
                                ScaffoldMessenger.of(context));
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
