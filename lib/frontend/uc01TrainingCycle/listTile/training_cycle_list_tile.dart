import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/listTile/training_cycle_list_tile_controller.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';

class TrainingCycleListTile extends StatefulWidget {
  final TrainingCycleBus trainingCycleBus;
  final bool planningMode;
  
  const TrainingCycleListTile({
    super.key,
    required this.trainingCycleBus,
    this.planningMode = false,
  });

  @override
  State<TrainingCycleListTile> createState() => _TrainingCycleListTileState();
}

class _TrainingCycleListTileState extends State<TrainingCycleListTile> {
  late TrainingCycleListTileController controller;

  @override
  void initState() {
    super.initState();
    controller = TrainingCycleListTileController(
      Provider.of<TrainingCycleProvider>(context, listen: false),
      widget.planningMode
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //dependent on if the view is in planning mode or not,
      //it either displays the planning view or otherwise the edit view 
      onTap: () => controller.onTileTap(context, widget.trainingCycleBus),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                shape: BoxShape.rectangle,
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(widget.trainingCycleBus.cycleName, 
                    style: Theme.of(context).textTheme.titleMedium
                  ),
                  Text(widget.trainingCycleBus.description),
                  Text(widget.trainingCycleBus.emphasis.join(', ')),
                  Text(widget.trainingCycleBus.beginDate.toString()),
                  Text(widget.trainingCycleBus.endDate.toString()),
                  if (widget.trainingCycleBus.parent != null) 
                    Text(widget.trainingCycleBus.parent!),
                ],
              ),
            ),
          ),
          Flexible(
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => controller.openEditView(context, widget.trainingCycleBus),
            ),
          ),
          Flexible(
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => controller.deleteCycle(
                widget.trainingCycleBus, 
                ScaffoldMessenger.of(context)
              ),
            ),
          ),
        ],
      ),
    );
  }
}


