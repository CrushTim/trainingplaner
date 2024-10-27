import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_edit_fields.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';

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
  @override
  Widget build(BuildContext context) {
    ExerciseFoundationBus exerciseFoundation = widget.exerciseFoundation;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(exerciseFoundation.exerciseFoundationName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add the image here
            Container(
              width: MediaQuery.of(context).size.width * 0.2, // 1/5th of screen width
              child: Image.asset(
                exerciseFoundation.exerciseFoundationPicturePath,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 10), // Add some spacing between image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(exerciseFoundation.exerciseFoundationDescription),
                  Text("Categories: ${exerciseFoundation.exerciseFoundationCategories.join(", ")}"),
                  Text("Muscle Groups: ${exerciseFoundation.exerciseFoundationMuscleGroups.join(", ")}"),
                  Text("People: ${exerciseFoundation.exerciseFoundationAmountOfPeople}"),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            final provider = Provider.of<ExerciseFoundationProvider>(context, listen: false);
            provider.setSelectedBusinessClass(exerciseFoundation);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: provider,
                  child: const ExerciseFoundationEditFields(),
                ),
              ),
            );
          },
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}