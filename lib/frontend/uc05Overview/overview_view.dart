import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_overview_view.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc05Overview/overview_provider.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({super.key});

  @override
  State<OverviewView> createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  
  
  @override
  Widget build(BuildContext context) {
    OverviewProvider overviewProvider = Provider.of<OverviewProvider>(context);
    final cycleProvider = Provider.of<TrainingCycleProvider>(context);
    final sessionProvider = Provider.of<TrainingSessionProvider>(context);
    overviewProvider.initializeProviders(sessionProvider, cycleProvider);

    return Scaffold(
      body: overviewProvider.streamBuilderForOverview(),
      appBar: AppBar(
        title: const Text("Weekly - Overview"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: cycleProvider,
                child: const TrainingCycleOverviewView(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}