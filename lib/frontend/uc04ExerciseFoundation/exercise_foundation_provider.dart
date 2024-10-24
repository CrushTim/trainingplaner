import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trainingplaner/business/businessClasses/exercise_foundation_bus.dart';
import 'package:trainingplaner/business/reports/excercise_foundation_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';

class ExerciseFoundationProvider extends TrainingsplanerProvider<ExerciseFoundationBus, ExerciseFoundationBusReport> {
  ExerciseFoundationProvider() : super(businessClassForAdd: ExerciseFoundationBus(exerciseFoundationId: "", exerciseFoundationName: "", exerciseFoundationDescription: "", exerciseFoundationPicturePath: "", exerciseFoundationCategories: [], exerciseFoundationMuscleGroups: [], exerciseFoundationAmountOfPeople: 1,), reportTaskVar: ExerciseFoundationBusReport(),);


  // /////////////////////////////////////////////////////////////////////
  //                         View Methods
  // /////////////////////////////////////////////////////////////////////

  StreamBuilder2 getAllExerciseFoundationsWithUserLinks() {
    return StreamBuilder2(
      streams: StreamTuple2(reportTaskVar.getAll(), ExerciseFoundationBusReport().getAll()),
      builder: (context, snapshots) {
        if (snapshots.snapshot1.connectionState == ConnectionState.waiting || snapshots.snapshot2.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshots.snapshot1.hasError || snapshots.snapshot2.hasError) {
          return Text(snapshots.snapshot1.error.toString() + snapshots.snapshot2.error.toString());
        } else {
          return Column(
            children: snapshots.snapshot1.data!.map((exerciseFoundation) {
              return Column(
                children: <Widget>[
                  Text(exerciseFoundation.exerciseFoundationName),
                  Text(exerciseFoundation.exerciseFoundationDescription),
                  Text(exerciseFoundation.exerciseFoundationPicturePath),
                  Text(exerciseFoundation.exerciseFoundationCategories.join(",")),
                  Text(exerciseFoundation.exerciseFoundationMuscleGroups.join(",")),
                  Text(exerciseFoundation.exerciseFoundationAmountOfPeople.toString()),
                  const SizedBox(height: 16), // Add some spacing between each exercise foundation
                ],
              );
            }).toList().cast<Widget>(), // Add .cast<Widget>() here
          );
        }
      },
    );
  }
}
