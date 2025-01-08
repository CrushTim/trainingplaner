import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/user_specific_exercise_data.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/oneRepMax/listTile/user_specific_one_rep_max_list_tile_controller.dart';

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
  late UserSpecificOneRepMaxListTileController controller;

  @override
  void initState() {
    super.initState();
    controller = UserSpecificOneRepMaxListTileController(
      Provider.of<ExerciseFoundationProvider>(context, listen: false)
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${widget.userSpecificExercise.oneRepMax.toString()} ${getDateStringForDisplay(widget.userSpecificExercise.date)} ${getTimeStringForDisplay(widget.userSpecificExercise.date)}"
      ),
      trailing: SizedBox(
        width: 96,
        child: Row(
          children: [
            IconButton(
              onPressed: () => controller.openEditDialog(context, widget.userSpecificExercise),
              icon: const Icon(Icons.edit)
            ),
            IconButton(
              onPressed: () => controller.deleteOneRepMax(
                widget.userSpecificExercise, 
                ScaffoldMessenger.of(context)
              ),
              icon: const Icon(Icons.delete)
            ),
          ],
        ),
      ),
    );
  }
}
