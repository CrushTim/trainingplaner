import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_overview_view.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc05Overview/overview_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_view.dart';

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
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              MediaQuery.of(context).size.width - 200,
              MediaQuery.of(context).size.height - 200,
              MediaQuery.of(context).size.width - 150,
              MediaQuery.of(context).size.height - 250,
            ),
            items: [
              PopupMenuItem(
                child: const Text('Training Cycle'),
                onTap: () {
                  // Wrap in Future.delayed to avoid navigator conflict with popup
                  Future.delayed(Duration.zero, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: cycleProvider,
                          child: const TrainingCycleOverviewView(),
                        ),
                      ),
                    );
                  });
                },
              ),
              PopupMenuItem(
                child: const Text('Planning'),
                onTap: () {
                  Future.delayed(Duration.zero, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(value: cycleProvider),
                            ChangeNotifierProvider.value(value: sessionProvider),
                            ChangeNotifierProvider.value(value: overviewProvider),
                          ],
                          child: const PlanningView(),
                        ),
                      ),
                    );
                  });
                },
              ),
            ],
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
