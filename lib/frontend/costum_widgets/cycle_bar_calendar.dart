import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/editFields/training_cycle_edit_fields.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
class CycleBarCalendar extends StatelessWidget {
  final String title;
  final Color color;
  final TrainingCycleBus? cycle; 
  const CycleBarCalendar({
    super.key,
    required this.title,
    required this.color,
    required this.cycle,
  });

  @override
  Widget build(BuildContext context) {
    TrainingCycleProvider trainingCycleProvider = Provider.of<TrainingCycleProvider>(context);
    return GestureDetector(
      onTap: () {
        if(cycle != null){
          trainingCycleProvider.setSelectedBusinessClass(cycle!);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
            value: trainingCycleProvider,
            child: const TrainingCycleEditFields(),
          )));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          shape: BoxShape.rectangle,
          color: color,
        ),
        height: 20,
        width: MediaQuery.of(context).size.width,
        child: Text(
          title,
        ),
      ),
    );
  }
}
