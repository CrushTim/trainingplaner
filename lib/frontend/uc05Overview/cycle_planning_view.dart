import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/costum_widgets/cycle_bar_calendar.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_day_field_calendar.dart';

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
  Map<DateTime, List<dynamic>> generateSessionDateMap() {
    Map<DateTime, List<dynamic>> sessionDateMap = {};
    DateTime startDate = widget.cycle.beginDate;
    DateTime endDate = widget.cycle.endDate;

    for (DateTime date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      sessionDateMap[DateTime(date.year, date.month, date.day)] = [];
    }
    return sessionDateMap;
  }

  Map<int, List<DateTime>> mapSessionsToWeeks(Map<DateTime, List<dynamic>> sessionDateMap) {
    Map<int, List<DateTime>> weekMap = {};
    
    // Helper function to get ISO week number
    int getISOWeekNumber(DateTime date) {
      // Shift to Monday being first day of week (ISO standard)
      int dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
      int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
      
      // Handle edge cases at year boundaries
      if (woy < 1) {
        // If week < 1, it belongs to the last week of previous year
        return getISOWeekNumber(DateTime(date.year - 1, 12, 31));
      } else if (woy > 52) {
        // Check if this is actually week 1 of next year
        DateTime lastDayOfYear = DateTime(date.year, 12, 31);
        if (getISOWeekNumber(lastDayOfYear) == 1) {
          return 1;
        }
      }
      return woy;
    }

    // Group dates by ISO week
    for (DateTime date in sessionDateMap.keys) {
      int weekNumber = getISOWeekNumber(date);
      
      if (!weekMap.containsKey(weekNumber)) {
        weekMap[weekNumber] = [];
      }
      weekMap[weekNumber]!.add(date);
    }

    // Ensure each week has exactly 7 days
    weekMap.forEach((weekNumber, dates) {
      if (dates.length < 7) {
        // Find the Monday of this week
        DateTime firstDate = dates.first;
        DateTime monday = firstDate.subtract(Duration(days: firstDate.weekday - 1));
        
        // Add any missing days
        for (int i = 0; i < 7; i++) {
          DateTime currentDate = monday.add(Duration(days: i));
          if (!dates.any((d) => d.year == currentDate.year && 
                              d.month == currentDate.month && 
                              d.day == currentDate.day)) {
            dates.add(currentDate);
          }
        }
        // Sort the dates
        dates.sort();
      }
    });

    return weekMap;
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<TrainingSessionProvider>(context);
    final cycleProvider = Provider.of<TrainingCycleProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Planning: ${widget.cycle.cycleName}'),
      ),
      body: StreamBuilder2(
        streams: StreamTuple2(
          sessionProvider.reportTaskVar.getAll(),
          cycleProvider.reportTaskVar.getAll(),
        ),
        builder: (context, snapshots) {
          if (snapshots.snapshot1.hasError || snapshots.snapshot2.hasError) {
            return Text(snapshots.snapshot1.error?.toString() ?? snapshots.snapshot2.error.toString());
          }
          if (snapshots.snapshot1.connectionState == ConnectionState.waiting ||
              snapshots.snapshot2.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = snapshots.snapshot1.data!.where(
            (session) => session.trainingCycleId == widget.cycle.getId()
          ).toList();

          final cycles = snapshots.snapshot2.data!;
          final childCycles = cycles.where(
            (cycle) => cycle.parent == widget.cycle.getId()
          ).toList();

          Map<DateTime, List<dynamic>> sessionDateMap = generateSessionDateMap();
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

          Map<int, List<DateTime>> weekMap = mapSessionsToWeeks(sessionDateMap);

          return ListView(
            children: List.generate(weekMap.length, (index) {
              return Column(
                children: <Widget>[
                  CycleBarCalendar(
                    cycle: null,
                    title: 'Week ${weekMap.keys.elementAt(index)}',
                    color: Colors.grey,
                  ),
                  for (var childCycle in childCycles)
                    if (childCycle.beginDate.isBefore(weekMap.entries.elementAt(index).value.last.add(const Duration(days: 1))) &&
                        childCycle.endDate.isAfter(weekMap.entries.elementAt(index).value.first.subtract(const Duration(days: 1))))
                      CycleBarCalendar(
                        cycle: childCycle,
                        title: childCycle.getName(),
                        color: Colors.blue,
                      ),
                  Row(
                    children: List.generate(
                      weekMap.entries.elementAt(index).value.length,
                      (dayIndex) {
                        final date = weekMap.entries.elementAt(index).value[dayIndex];
                        return Expanded(
                          child: PlanningDayFieldCalendar(
                            date: date,
                            workouts: sessionDateMap[date] ?? [],
                            onAddPressed: () {
                              // TODO: Implement add session functionality for this specific date
                              print('Add pressed for date: $date');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add session functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 