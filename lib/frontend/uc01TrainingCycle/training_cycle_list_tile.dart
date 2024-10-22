import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_edit_fields.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';

class TrainingCycleListTile extends StatefulWidget {
  final TrainingCycleBus trainingCycleBus;
  const TrainingCycleListTile({
    super.key,
    required this.trainingCycleBus,
  });

  @override
  State<TrainingCycleListTile> createState() => _TrainingCycleListTileState();
}

class _TrainingCycleListTileState extends State<TrainingCycleListTile> {
  @override
  Widget build(BuildContext context) {
    TrainingCycleProvider trainingCycleProvider = Provider.of<TrainingCycleProvider>(context);
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              shape: BoxShape.rectangle,
              color: Colors.blue,
            ),
            child: Column(
              children: [
                Text(widget.trainingCycleBus.cycleName, style: Theme.of(context).textTheme.titleMedium),
                Text(widget.trainingCycleBus.description),
                Text(widget.trainingCycleBus.emphasis.join(', ')),
                Text(widget.trainingCycleBus.beginDate.toString()),
                Text(widget.trainingCycleBus.endDate.toString()),
                if (widget.trainingCycleBus.parent != null) Text(widget.trainingCycleBus.parent!),
              ],
            ),
          ),
        ),
      
      Flexible(
        child: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            trainingCycleProvider.setSelectedBusinessClass(widget.trainingCycleBus);
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(value: trainingCycleProvider, child: const TrainingCycleEditFields())));
          },
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
    );
  }
}


