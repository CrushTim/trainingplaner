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
      body: StreamBuilder(
        stream: sessionProvider.reportTaskVar.getAll(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError){
            return const Center(child: Text("Error"),);
          }

          Map<DateTime, List<dynamic>> sessionDateMap = generateSessionDateMap();

          for(var session in snapshot.data!) {
            DateTime date = session.trainingSessionStartDate;
            
            for(DateTime datee in sessionDateMap.keys){
              if(date.year == datee.year && date.month == datee.month && date.day == datee.day){
                print(datee);
                sessionDateMap[datee]!.add(session);
              }
            }
          }
          print(snapshot.data!);
          print(sessionDateMap.values);

          Map<int, List<DateTime>> weekMap = mapSessionsToWeeks(sessionDateMap);

          return ListView(
            children: List.generate(weekMap.length, (index) {
              return Column(
                children: <Widget>[
                  CycleBarCalendar(title: weekMap.keys.elementAt(index).toString(), color: Colors.grey),
                  ...List<Widget>.generate(cycles, (index) {
                    return CycleBarCalendar(title: "Cycle $index", color: Colors.blue);
                  }),
                  Row(
                    //TODO: make week to calendar week and check for right assignment
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
// ListView(
//         children: List.generate(52, (index) {
//           return Column(
//             children: <Widget>[
//                   CycleBarCalendar(
//                       title: "Week ${index + 1}", color: Colors.grey),
//                 ] +
//                 List<Widget>.generate(cycles, (index) {
//                   return CycleBarCalendar(
//                       title: "Cycle $index", color: Colors.blue);
//                 }) +
//                 [
//                   //THE days in the week
//                   Row(
//                     children: List.generate(7, (indexx) {
//                       return Expanded(
//                         child: DayFieldCalendar(
//                           date: DateTime(2024, 1, 1)
//                               .add(Duration(days: ((index + 1) * 7 + indexx))),
//                           workouts: const ["upper body", "flexibility"],
//                         ),
//                       );
//                     }),
//                   )
//                 ],
//           );
//         }),
//       ),