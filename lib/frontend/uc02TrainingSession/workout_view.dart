import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/add_exercise_edit_fields.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/workout_selection_view.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout"), 
      ),
      body: ListView(
        children: [
          sessionProvider.getCurrentTrainingSessionStreamBuilder(),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ChangeNotifierProvider.value(
                  value: sessionProvider,
                  child: const AddExerciseEditFields(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    child: const Text("Update Diary Entry"),
                    onPressed: () {
                      sessionProvider
                          .updateSessionInDatabase(ScaffoldMessenger.of(context));
                    }),
              ),
              Expanded(
                child: ElevatedButton(
                    child: const Text("Finish Workout"),
                    onPressed: () {
                      //TODO: implement provider finish of selected workout (save diary entry and move selected workout to the next workout);
                      sessionProvider.businessClassForAdd.trainingSessionName = "NEW WORKOUT";
                      sessionProvider.businessClassForAdd.trainingSessionDescription = "NEW WORKOUT DESCRIPTION";
                      sessionProvider.businessClassForAdd.isPlanned = false;
                      sessionProvider.businessClassForAdd.plannedSessionId = null;
                      sessionProvider.businessClassForAdd.trainingSessionEmphasis = ["Hyperthrophy"];
                      sessionProvider.businessClassForAdd.trainingSessionLength = 90;
                      sessionProvider.businessClassForAdd.trainingSessionStartDate = DateTime.now();
                      sessionProvider.addBusinessClass(sessionProvider.getBusinessClassForAdd, ScaffoldMessenger.of(context));
                    }),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: sessionProvider,
                child: const WorkoutSelectionView(),
              ),
            ),
          );
        },
        child: const Icon(Icons.list),
      ),
    );
  }
}
