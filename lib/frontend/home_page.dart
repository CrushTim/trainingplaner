import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_overview_view.dart';
import 'package:trainingplaner/frontend/views/overview_view.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/workout_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _tabController!.addListener(() {
      setState(() {});
    });
    return Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: const [OverviewView(), WorkoutView(), ExerciseFoundationOverviewView()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabController!.index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_view_day),
                label: "Overview",
                activeIcon: Icon(Icons.calendar_view_day, color: Colors.blue)),
            BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: "Workout",
                activeIcon: Icon(Icons.fitness_center, color: Colors.blue)),
            BottomNavigationBarItem(
                icon: Icon(Icons.fit_screen),
                label: "Exercise Foundation",
                activeIcon: Icon(Icons.fit_screen, color: Colors.blue)),
          ],
          onTap: (value) {
            switch (value) {
              case 0:
                _tabController!.animateTo(0);
                break;
              case 1:
                _tabController!.animateTo(1);
                break;
              case 2:
                _tabController!.animateTo(2);
                break;
            }
          },
        ));
  }
}
