import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class CyclePlanningView extends StatefulWidget {
  final TrainingCycleBus cycle;
  
  const CyclePlanningView({
    super.key,
    required this.cycle,
  });

  @override
  State<CyclePlanningView> createState() => _CyclePlanningViewState();
}

class _CyclePlanningViewState extends State<CyclePlanningView> {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<TrainingSessionProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Planning: ${widget.cycle.cycleName}'),
      ),
      body: StreamBuilder(
        stream: sessionProvider.reportTaskVar.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = snapshot.data!.where(
            (session) => session.trainingCycleId == widget.cycle.getId()
          ).toList();

          return ListView.builder(
            itemCount: sessions.length + 1,  // +1 for the add button
            itemBuilder: (context, index) {
              if (index == sessions.length) {
                return ElevatedButton(
                  onPressed: () {
                    // TODO: Implement add session functionality
                  },
                  child: const Text('Add Session'),
                );
              }

              final session = sessions[index];
              return ListTile(
                title: Text(session.trainingSessionName),
                subtitle: Text(session.trainingSessionDescription),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Implement edit session
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // TODO: Implement delete session
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
} 