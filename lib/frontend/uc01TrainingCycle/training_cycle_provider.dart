import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/business/reports/trainings_cycle_bus_report.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/cycle_draggable.dart';

class TrainingCycleProvider
    extends TrainingsplanerProvider<TrainingCycleBus, TrainingCycleBusReport> {
  TrainingCycleProvider()
      : super(
            businessClassForAdd: TrainingCycleBus(
                trainingCycleID: "",
                cycleName: "",
                description: "",
                emphasis: "",
                beginDate: DateTime.now(),
                endDate: DateTime.now()),
            reportTaskVar: TrainingCycleBusReport());


            ///Method to retrieve of the training cycles to return as draggables and 
            ///to be used in the edit_cycles_view
            StreamBuilder<List<TrainingCycleBus>> getTrainingCycles() {
              return StreamBuilder<List<TrainingCycleBus>>(
                stream: reportTaskVar.getAll(),
                builder: (context, snapshot) {
                    if(snapshot.hasError) {
                      return  Text(snapshot.error.toString());
                    } if(snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CycleDraggable(trainingCycleBus: snapshot.data![index]);
                      }
                    );
                },
              );
            }
}


