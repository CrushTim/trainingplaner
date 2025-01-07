import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/add_exercise_edit_fields.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/add_planning_exercise_tile.dart';

class AddPlanningSessionDialog extends StatefulWidget {
  final DateTime initialDate;
  final String cycleId;

  const AddPlanningSessionDialog({
    super.key,
    required this.initialDate,
    required this.cycleId,
  });

  @override
  State<AddPlanningSessionDialog> createState() => _AddPlanningSessionDialogState();
}

class _AddPlanningSessionDialogState extends State<AddPlanningSessionDialog> {
  @override
  void initState() {
    super.initState();
    PlanningProvider provider = Provider.of<PlanningProvider>(context, listen: false);
    provider.selectedSessionDate = widget.initialDate;
    provider.initControllersForPlanningView();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanningProvider>(context);
    print('provider.getSelectedBusinessClass: ${provider.getSelectedBusinessClass?.trainingSessionExercises}');


    return Dialog(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: provider.sessionNameController,
                decoration: const InputDecoration(labelText: 'Session Name'),
                onChanged: (value) => provider.handleSessionFieldChangeForPlanned('name', value),
              ),
              TextField(
                controller: provider.sessionDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => provider.handleSessionFieldChangeForPlanned('description', value),
              ),
              TextField(
                controller: provider.sessionEmphasisController,
                decoration: const InputDecoration(labelText: 'Emphasis (comma separated)'),
                onChanged: (value) => provider.handleSessionFieldChangeForPlanned('emphasis', value),
              ),
              TextField(
                controller: provider.sessionLengthController,
                decoration: const InputDecoration(labelText: 'Length (minutes)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => provider.handleSessionFieldChangeForPlanned('length', value),
              ),
              DatePickerSheer(
                initialDateTime: provider.selectedSessionDate,
                onDateTimeChanged: provider.updateSessionDate,
                dateController: TextEditingController(
                  text: provider.selectedSessionDate.toString()
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context, 
                        builder: (context) => ChangeNotifierProvider.value(
                          value: provider, 
                          child: const AddExerciseEditFields(addPlanned: true)
                        ),
                      ).then((value) {
                        if (value != null) {
                          provider.exercisesToDeleteIfSessionAddIsCancelled.add(value);
                        }
                        setState(() {});
                        provider.exerciseProvider.resetBusinessClassForAdd();
                      });
                    }, 
                    child: const Text("Add Exercise")
                  ),
                  if (provider.getSelectedBusinessClass != null)
                    ...provider.getSelectedBusinessClass!.trainingSessionExercises.map(
                      (exercise) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: AddPlanningExerciseTile(
                          exercise: exercise,
                          onUpdate: (updatedExercise) {
                            ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
                            provider.exerciseProvider.updateBusinessClass(updatedExercise, scaffoldMessenger);
                            if(provider.getSelectedBusinessClass != null){
                              provider.updateSelectedBusinessClass(scaffoldMessenger, notify: false);
                            } 
                          },
                          onDelete: (exercise) {
                            setState(() {
                              provider.getSelectedBusinessClass!.trainingSessionExercises.remove(exercise);
                              provider.getSelectedBusinessClass!.trainingSessionExcercisesIds.remove(exercise.trainingExerciseID);
                            });
                          },
                        ),
                      ),
                    )
                  else
                    ...provider.businessClassForAdd.trainingSessionExercises.map(
                      (exercise) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: AddPlanningExerciseTile(
                          exercise: exercise,
                          onUpdate: (updatedExercise) {
                            ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
                            provider.exerciseProvider.updateBusinessClass(updatedExercise, scaffoldMessenger);
                          },
                          onDelete: (exercise) {
                            setState(() {
                              provider.businessClassForAdd.trainingSessionExercises.remove(exercise);
                              provider.businessClassForAdd.trainingSessionExcercisesIds.remove(exercise.trainingExerciseID);
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (provider.getSelectedBusinessClass != null) {
                        provider.getSelectedBusinessClass!.trainingCycleId = widget.cycleId;
                      } else {
                        provider.businessClassForAdd.trainingCycleId = widget.cycleId;
                      }
                      provider.saveSession(context);
                    },
                    child: Text(provider.getSelectedBusinessClass != null ? 'Update' : 'Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
} 