import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/frontend/costum_widgets/cycle_bar_calendar.dart';
import 'package:trainingplaner/frontend/uc05Overview/dayField/day_field_calendar.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class OverviewProvider extends ChangeNotifier {
  late TrainingSessionProvider sessionProvider;
  late TrainingCycleProvider cycleProvider;


  void initializeProviders(TrainingSessionProvider sessionProv, TrainingCycleProvider cycleProv) {
    sessionProvider = sessionProv;
    cycleProvider = cycleProv;
  }

  Map<DateTime, List<dynamic>> generateSessionDateMap() {
    Map<DateTime, List<dynamic>> sessionDateMap = {};
    DateTime startDate = DateTime(DateTime.now().year);
    DateTime endDate = DateTime(DateTime.now().year + 1);

    // Initialize map with all dates of the year
    for (var date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      sessionDateMap[DateTime(date.year, date.month, date.day)] = [];
    }

    return sessionDateMap;
  }

  Map<int, List<DateTime>> mapSessionsToWeeks(
      Map<DateTime, List<dynamic>> sessionDateMap) {
    Map<int, List<DateTime>> weekMap = {};

    // Helper function to get ISO week number
    int getISOWeekNumber(DateTime date) {
      // Find Thursday of the current week
      DateTime thursday = date.subtract(Duration(days: date.weekday - DateTime.thursday));
      
      // Find the first Thursday of the year
      DateTime firstThursday = DateTime(thursday.year, 1, 1);
      while (firstThursday.weekday != DateTime.thursday) {
        firstThursday = firstThursday.add(const Duration(days: 1));
      }
      
      // Calculate the week number
      int weekNumber = 1 + thursday.difference(firstThursday).inDays ~/ 7;
      return weekNumber;
    }

    // Helper function to get the Monday of a given week
    DateTime getMondayOfWeek(DateTime date) {
      return date.subtract(Duration(days: date.weekday - DateTime.monday));
    }

    // Group dates by ISO week
    for (DateTime date in sessionDateMap.keys) {
      int weekNumber = getISOWeekNumber(date);
      
      if (!weekMap.containsKey(weekNumber)) {
        // Initialize the week with all 7 days
        DateTime monday = getMondayOfWeek(date);
        weekMap[weekNumber] = List.generate(
          7,
          (index) => monday.add(Duration(days: index)),
        );
      }
    }

    // Sort weeks
    var sortedWeeks = Map.fromEntries(
      weekMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );

    return sortedWeeks;
  }

  // Helper function to calculate weeks in a year
  int getWeeksInYear(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 =
        int.parse(dec28.difference(DateTime(year, 1, 1)).inDays.toString());
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  void populateSessionDateMap(Map<DateTime, List<dynamic>> sessionDateMap,
      List<TrainingSessionBus> sessions) {
    for (var session in sessions) {
      DateTime date = session.trainingSessionStartDate;

      for (DateTime mapDate in sessionDateMap.keys) {
        if (date.year == mapDate.year &&
            date.month == mapDate.month &&
            date.day == mapDate.day) {
          sessionDateMap[mapDate]!.add(session);
        }
      }
    }
  }

   StreamBuilder3 streamBuilderForOverview() {
    return StreamBuilder3(
      streams: StreamTuple3(
        sessionProvider.reportTaskVar.getAll(),
        sessionProvider.exerciseProvider.reportTaskVar.getAll(),
        cycleProvider.reportTaskVar.getAll(),
      ),
      builder: (context, snapshot) {
        if (snapshot.snapshot1.connectionState == ConnectionState.waiting ||
            snapshot.snapshot2.connectionState == ConnectionState.waiting ||
            snapshot.snapshot3.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.snapshot1.hasError ||
            snapshot.snapshot2.hasError ||
            snapshot.snapshot3.hasError) {
          if (snapshot.snapshot1.hasError) {
            return Text(snapshot.snapshot1.error.toString());
          }
          if (snapshot.snapshot2.hasError) {
            return Text(snapshot.snapshot2.error.toString());
          }
          if (snapshot.snapshot3.hasError) {
            return Text(snapshot.snapshot3.error.toString());
          }
        }

        final sessions = snapshot.snapshot1.data!;
        final exercises = snapshot.snapshot2.data!;
        final cycles = snapshot.snapshot3.data!;

        sessionProvider.initializeSessionMaps(sessions, exercises);
        Map<DateTime, List<dynamic>> sessionDateMap = generateSessionDateMap();
        populateSessionDateMap(sessionDateMap, sessions);
        Map<int, List<DateTime>> weekMap = mapSessionsToWeeks(sessionDateMap);
        sessionProvider.allCycles = cycles;

        return ListView(
          children: List.generate(weekMap.length, (index) {
            return Column(
              children: <Widget>[
                CycleBarCalendar(
                  cycle: null,
                  title: 'Week ${weekMap.keys.elementAt(index)}',
                  color: Colors.grey,
                ),
                for (var cycle in cycles)
                  if (cycle.beginDate.isBefore(weekMap.entries
                          .elementAt(index)
                          .value
                          .last
                          .add(const Duration(days: 1))) &&
                      cycle.endDate.isAfter(weekMap.entries
                          .elementAt(index)
                          .value
                          .first
                          .subtract(const Duration(days: 1))))
                    CycleBarCalendar(
                      cycle: cycle,
                      title: cycle.getName(),
                      color: Colors.blue,
                    ),
                Row(
                  children: List.generate(
                      weekMap.entries.elementAt(index).value.length, (indexx) {
                    final date =
                        weekMap.entries.elementAt(index).value.elementAt(indexx);
                    return Expanded(
                      child: DayFieldCalendar(
                        date: date,
                        workouts: sessionDateMap[date] ?? [],
                      ),
                    );
                  }),
                )
              ],
            );
          }),
        );
      },
    );
  }
}