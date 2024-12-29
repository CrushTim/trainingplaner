import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_edit_fields.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';

class ExerciseFoundationOverviewView extends StatefulWidget {
  const ExerciseFoundationOverviewView({super.key});

  @override
  State<ExerciseFoundationOverviewView> createState() => _ExerciseFoundationOverviewViewState();
}

class _ExerciseFoundationOverviewViewState extends State<ExerciseFoundationOverviewView> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseFoundationProvider>(context, listen: false)
        .loadMoreFoundations();
    });
  }

  @override
  Widget build(BuildContext context) {
    ExerciseFoundationProvider exerciseFoundationProvider = 
      Provider.of<ExerciseFoundationProvider>(context);
      
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Foundations'),
      ),
      body: exerciseFoundationProvider.getAllExerciseFoundationsWithUserLinks(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          exerciseFoundationProvider.setSelectedBusinessClass(null);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: exerciseFoundationProvider,
                child: const ExerciseFoundationEditFields(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
