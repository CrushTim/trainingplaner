import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/user_specific_one_rep_max_edit_fields.dart';

class UserSpecificOneRepMaxListTile extends StatefulWidget {
  final UserSpecificExerciseBus userSpecificExercise;
  const UserSpecificOneRepMaxListTile({
    super.key,
    required this.userSpecificExercise,
  });

  @override
  State<UserSpecificOneRepMaxListTile> createState() => _UserSpecificOneRepMaxListTileState();
}

class _UserSpecificOneRepMaxListTileState extends State<UserSpecificOneRepMaxListTile> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExerciseFoundationProvider>(context);
    return ListTile(
      title: Text("${widget.userSpecificExercise.oneRepMax.toString()} ${getDateStringForDisplay(widget.userSpecificExercise.date)} ${getTimeStringForDisplay(widget.userSpecificExercise.date)}"),
      trailing: SizedBox(
        width: 96, // Gives enough space for two icons
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                provider.setSelectedUserSpecificExercise(widget.userSpecificExercise);
                provider.initialDateTime = widget.userSpecificExercise.date;
                await showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) => ChangeNotifierProvider.value(
                    value: provider,
                    child: Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserSpecificOneRepMaxEditFields(
                            userSpecificExercise: widget.userSpecificExercise
                          ),
                        ],
                      ),
                    ),
                  ),
                ).then((_) {
                  if (_ == true) {
                    provider.userSpecificExercise.add(provider.userSpecificExerciseBusForAdd);
                    setState(() {});
                  }
                  
                provider.resetUserSpecificExerciseForAdd();
                provider.resetSelectedUserSpecificExercise();
                
                  provider.onDateTimeChangedUserSpecificExercise(DateTime.now());
                  provider.initialDateTime = DateTime.now();
                });
              },
              icon: const Icon(Icons.edit)
            ),
            IconButton(
                onPressed: () {
                  provider.deleteUserSpecificExercise(widget.userSpecificExercise, ScaffoldMessenger.of(context));
                  provider.userSpecificExercise.remove(widget.userSpecificExercise);
              },
              icon: const Icon(Icons.delete)
            ),
          ],
        ),
      ),
    );
  }
}
