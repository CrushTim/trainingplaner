import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/costum_widgets/cycle_bar_calendar.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc05Overview/overview_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/add_planning_session_dialog.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_day_field_calendar.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

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
    
    for(var date in sessionDateMap.keys){
      int woy = ((date.difference(DateTime(date.year, 1, 1)).inDays + 
          DateTime(date.year, 1, 1).weekday) / 7).ceil();
      
      if (!weekMap.containsKey(woy)) {
        weekMap[woy] = [];
      }
      weekMap[woy]!.add(date);
    }
    
    weekMap.forEach((week, dates) {
      dates.sort();
    });
    
    return weekMap;
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<TrainingSessionProvider>(context);
    final cycleProvider = Provider.of<TrainingCycleProvider>(context);
    final overviewProvider = Provider.of<OverviewProvider>(context);
    final planningProvider = Provider.of<PlanningProvider>(context);
    
    overviewProvider.initializeProviders(sessionProvider, cycleProvider);
    
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
                  Row(
                    children: List.generate(
                      weekMap.entries.elementAt(index).value.length,
                      (dayIndex) {
                        final date = weekMap.entries.elementAt(index).value[dayIndex];
                        planningProvider.selectedSessionDate = date;
                        return Expanded(
                          child: PlanningDayFieldCalendar(
                            date: date,
                            workouts: sessionDateMap[date] ?? [],
                            onAddPressed: () {
                              print("date: $date");
                              showDialog(
                                context: context, 
                                builder: (context) => ChangeNotifierProvider.value(
                                  value: planningProvider,
                                  child: AddPlanningSessionDialog(
                                    initialDate: date, 
                                    cycleId: widget.cycle.getId()
                                  ),
                                )
                              );
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
    );
  }
}
