import 'package:flutter/material.dart';

class CycleEditColumn extends StatelessWidget {
  const CycleEditColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        shape: BoxShape.rectangle,
        color: Colors.grey[300],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.fitness_center),
            tooltip: 'Target 1RM',
            onPressed: () {
              // TODO: Implement target 1RM functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward),
            tooltip: 'Deload',
            onPressed: () {
              // TODO: Implement deload functionality
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'option1',
                child: Text('To Implement 1'),
              ),
              const PopupMenuItem(
                value: 'option2',
                child: Text('To Implement 2'),
              ),
              const PopupMenuItem(
                value: 'option3',
                child: Text('To Implement 3'),
              ),
            ],
            onSelected: (value) {
              // TODO: Implement additional options
            },
          ),
        ],
      ),
    );
  }
} 