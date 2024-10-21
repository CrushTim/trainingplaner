import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';

class CycleDraggable extends StatelessWidget {
  final TrainingCycleBus trainingCycleBus;
  const CycleDraggable({
    super.key,
    required this.trainingCycleBus,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: const Text("Drag me!"),
      childWhenDragging: const Text("I'm being dragged!"),
      onDragEnd: (details) {
        //TODO update the list
      },
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                shape: BoxShape.rectangle,
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(trainingCycleBus.cycleName),
                  Text(trainingCycleBus.description),
                  Text(trainingCycleBus.emphasis),
                  Text(trainingCycleBus.beginDate.toString()),
                  Text(trainingCycleBus.endDate.toString()),
                  Text(trainingCycleBus.parent ?? ""),
                ],
              ),
            ),
          ),
          Flexible(
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
          ),
          Flexible(
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                //TODO delete the cycle
              },
            ),
          ),
        ],
      ),
    );
  }
}
