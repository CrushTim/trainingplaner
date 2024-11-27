import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/frontend/costum_widgets/cycle_bar_calendar.dart';
import 'package:trainingplaner/frontend/uc05Overview/day_field_calendar.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_overview_view.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({super.key});

  @override
  State<OverviewView> createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  @override
  Widget build(BuildContext context) {

  Map<DateTime, List<dynamic>> generateSessionDateMap() {
    Map<DateTime, List<dynamic>> sessionDateMap = {};
    DateTime startDate = DateTime(DateTime.now().year);
    DateTime endDate = DateTime(DateTime.now().year + 1);

    // Initialize map with all dates of the year
    for (var date = startDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
      sessionDateMap[DateTime(date.year, date.month, date.day)] = [];
    }

    return sessionDateMap;
  }

  Map<int, List<DateTime>> mapSessionsToWeeks(Map<DateTime, List<dynamic>> sessionDateMap) {
    Map<int, List<DateTime>> weekMap = {};
    
  // Helper function to calculate weeks in a year
  int getWeeksInYear(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(dec28.difference(DateTime(year, 1, 1)).inDays.toString());
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }
    
    sessionDateMap.forEach((date, sessions) {
      // Get the ISO week number
      int dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
      int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
      
      // Skip dates that belong to previous/next year's weeks
      if (woy < 1 || woy > getWeeksInYear(date.year)) {
        return; // Skip this date
      }
      
      if (!weekMap.containsKey(woy)) {
        weekMap[woy] = [];
      }
      
      weekMap[woy]!.add(date);
    });
    
    // Sort dates within each week
    weekMap.forEach((week, dates) {
      dates.sort();
    });
    
    return weekMap;
  }


  TrainingSessionProvider sessionProvider = Provider.of<TrainingSessionProvider>(context);
  TrainingCycleProvider trainingCycleProvider = Provider.of<TrainingCycleProvider>(context);
  
    return Scaffold(
      body: StreamBuilder3(
        streams: StreamTuple3(
          sessionProvider.reportTaskVar.getAll(), 
          sessionProvider.exerciseProvider.reportTaskVar.getAll(),
          trainingCycleProvider.reportTaskVar.getAll()
        ),
        builder: (context, snapshot) {
          if(snapshot.snapshot1.connectionState == ConnectionState.waiting || 
             snapshot.snapshot2.connectionState == ConnectionState.waiting ||
             snapshot.snapshot3.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.snapshot1.hasError || snapshot.snapshot2.hasError || snapshot.snapshot3.hasError){
            if(snapshot.snapshot1.hasError){
              return Text(snapshot.snapshot1.error.toString());
            }
            if(snapshot.snapshot2.hasError){
              return Text(snapshot.snapshot2.error.toString());
            }
            if(snapshot.snapshot3.hasError){
              return Text(snapshot.snapshot3.error.toString());
            }
          }
          List<TrainingSessionBus> sessions = snapshot.snapshot1.data!;
          List<TrainingExerciseBus> exercises = snapshot.snapshot2.data!;
          List<TrainingCycleBus> cycles = snapshot.snapshot3.data!;
          
          sessionProvider.initializeSessionMaps(sessions, exercises);
          Map<DateTime, List<dynamic>> sessionDateMap = generateSessionDateMap();

          for(var session in sessions) {
            DateTime date = session.trainingSessionStartDate;
            
            for(DateTime datee in sessionDateMap.keys){
              if(date.year == datee.year && date.month == datee.month && date.day == datee.day){
                sessionDateMap[datee]!.add(session);
              }
            }
          }

          Map<int, List<DateTime>> weekMap = mapSessionsToWeeks(sessionDateMap);

          return ListView(
            children: List.generate(weekMap.length, (index) {
              return Column(
                children: <Widget>[
                  CycleBarCalendar(cycle: null, title: weekMap.keys.elementAt(index).toString(), color: Colors.grey),
                  for(var cycle in cycles)
                    if (cycle.beginDate.isBefore(weekMap.entries.elementAt(index).value.last.add(const Duration(days: 1))) &&
                        cycle.endDate.isAfter(weekMap.entries.elementAt(index).value.first.subtract(const Duration(days: 1))))
                        CycleBarCalendar(cycle: cycle, title: cycle.getName(), color: Colors.blue)
                  ,
                  Row(
                    children: List.generate(weekMap.entries.elementAt(index).value.length, (indexx) {
                      final date = weekMap.entries.elementAt(index).value.elementAt(indexx);

                      return Expanded(child: DayFieldCalendar(date: date, workouts: sessionDateMap[date] ?? [],),);
                    }),
                  )
                ],
              );
            }),
          );
        }
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