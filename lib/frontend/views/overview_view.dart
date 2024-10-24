import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/costum_widgets/cycle_bar_calendar.dart';
import 'package:trainingplaner/frontend/costum_widgets/day_field_calendar.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_overview_view.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({super.key});

  @override
  State<OverviewView> createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  int cycles = 2;
  @override
  Widget build(BuildContext context) {
  TrainingSessionProvider sessionProvider = Provider.of<TrainingSessionProvider>(context);
  TrainingCycleProvider trainingCycleProvider = Provider.of<TrainingCycleProvider>(context);
    return Scaffold(
      body: ListView(
        children: List.generate(52, (index) {
          return Column(
            children: <Widget>[
                  CycleBarCalendar(
                      title: "Week ${index + 1}", color: Colors.grey),
                ] +
                List<Widget>.generate(cycles, (index) {
                  return CycleBarCalendar(
                      title: "Cycle $index", color: Colors.blue);
                }) +
                [
                  //THE days in the week
                  Row(
                    children: List.generate(7, (indexx) {
                      return Expanded(
                        child: DayFieldCalendar(
                          date: DateTime(2024, 1, 1)
                              .add(Duration(days: ((index + 1) * 7 + indexx))),
                          workouts: const ["upper body", "flexibility"],
                        ),
                      );
                    }),
                  )
                ],
          );
        }),
      ),
      appBar: AppBar(
        title: const Text("Weekly - Overview"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                value: trainingCycleProvider,
                child: const TrainingCycleOverviewView(),
              ),),);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
