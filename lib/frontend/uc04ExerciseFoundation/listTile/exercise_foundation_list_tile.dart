import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/listTile/exercise_foundation_list_tile_controller.dart';

class ExerciseFoundationListTile extends StatefulWidget {
  final ExerciseFoundationBus exerciseFoundation;
  const ExerciseFoundationListTile({
    required this.exerciseFoundation,
    super.key,
  });

  @override
  State<ExerciseFoundationListTile> createState() => _ExerciseFoundationListTileState();
}

class _ExerciseFoundationListTileState extends State<ExerciseFoundationListTile> {
  late ExerciseFoundationListTileController controller;

  @override
  void initState() {
    super.initState();
    controller = ExerciseFoundationListTileController(
      Provider.of<ExerciseFoundationProvider>(context, listen: false)
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.sortOneRepMaxes(widget.exerciseFoundation);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.exerciseFoundation.exerciseFoundationName),
                  Text(widget.exerciseFoundation.exerciseFoundationDescription),
                  Text("Categories: ${widget.exerciseFoundation.exerciseFoundationCategories.join(", ")}"),
                  Text("Muscle Groups: ${widget.exerciseFoundation.exerciseFoundationMuscleGroups.join(", ")}"),
                  Text("People: ${widget.exerciseFoundation.exerciseFoundationAmountOfPeople}"),
                  Text("1 Rep max: ${controller.getLatestOneRepMax(widget.exerciseFoundation)}"),
                  Text("Notes: ${widget.exerciseFoundation.exerciseFoundationNotes?.exerciseFoundationNotes.join(", ")}"),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => controller.openEditView(context, widget.exerciseFoundation),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
