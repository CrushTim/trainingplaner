import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/frontend/costum_widgets/cycle_bar_calendar.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/workout_view.dart';
import 'package:trainingplaner/frontend/uc05Overview/day_field_calendar.dart';
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
        sessionProvider.trainingExerciseBusReport.getAll(),
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

        return ListView(
          children: List.generate(weekMap.length, (index) {
            return Column(
              children: <Widget>[
                CycleBarCalendar(
                  cycle: null,
                  title: weekMap.keys.elementAt(index).toString(),
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

  // //////////////////////////////////////////////////////////////
  // / /////////////////////////DAY FIELD////////////////////////
  // //////////////////////////////////////////////////////////////

  Map<dynamic, dynamic> separatePlannedAndUnplannedSessions(List workouts) {
    Map<dynamic, dynamic> plannedSessions = {};
    List unplannedSessions = [];

    // Separate planned and unplanned sessions
    for (var workout in workouts) {
      if (workout.isPlanned) {
        plannedSessions[workout] = null;
      } else {
        unplannedSessions.add(workout);
      }
    }

    // Map unplanned sessions to their planned sessions
    for (var unplannedSession in unplannedSessions) {
      if (unplannedSession.plannedSessionId != null) {
        var plannedSession = plannedSessions.keys.firstWhere(
          (session) => session.trainingSessionId == unplannedSession.plannedSessionId,
          orElse: () => null
        );
        if (plannedSession != null) {
          plannedSessions[plannedSession] = unplannedSession;
        }
      }
    }

    return plannedSessions;
  }

  List getUnpairedSessions(List unplannedSessions, Map<dynamic, dynamic> plannedSessions) {
    return unplannedSessions.where((session) => 
      !plannedSessions.values.contains(session) && 
      session.plannedSessionId == null
    ).toList();
  }

  List<Widget> buildSessionRows(
    BuildContext context,
    Map<dynamic, dynamic> plannedSessions,
    List unpaired,
    TrainingSessionProvider trainingSessionProvider
  ) {
    List<Widget> sessionRows = [];

    // Add planned-unplanned pairs
    for (var entry in plannedSessions.entries) {
      sessionRows.add(
        Row(
          children: [
            Expanded(
              child: _buildSessionTile(
                context,
                entry.key,
                entry.value,
                trainingSessionProvider,
                Colors.green,
              ),
            ),
            if (entry.value != null)
              Expanded(
                child: _buildSessionTile(
                  context,
                  entry.key,
                  entry.value,
                  trainingSessionProvider,
                  Colors.grey,
                ),
              ),
          ],
        )
      );
    }

    // Add unpaired unplanned sessions
    for (var session in unpaired) {
      sessionRows.add(
        Row(
          children: [
            Expanded(
              child: _buildSessionTile(
                context,
                null,
                session,
                trainingSessionProvider,
                Colors.grey,
              ),
            ),
          ],
        )
      );
    }

    return sessionRows;
  }

  Widget _buildSessionTile(
    BuildContext context,
    dynamic plannedSession,
    dynamic actualSession,
    TrainingSessionProvider trainingSessionProvider,
    Color color,
  ) {
    return GestureDetector(
      onTap: () async {
        trainingSessionProvider.setActualAndPlannedSession(
          plannedSession,
          actualSession
        );
        await Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: trainingSessionProvider, 
              child: const WorkoutView()
            )
          )
        );
        trainingSessionProvider.resetAllListsAndBusinessClasses();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: color,
        ),
        child: Text(
          (actualSession ?? plannedSession).trainingSessionName
        ),
      ),
    );
  }

  List<Widget> buildPlanningSessionRows(
    BuildContext context,
    Map<dynamic, dynamic> plannedSessions,
    List unpaired,
    TrainingSessionProvider trainingSessionProvider,
    DateTime date,
  ) {
    List<Widget> sessionRows = [];
    DateTime? lastTappedSession;
    DateTime lastTapTime = DateTime.now();

    Widget buildPlanningSessionTile(
      dynamic plannedSession,
      dynamic actualSession,
      TrainingSessionProvider trainingSessionProvider,
      Color color,
    ) {
      return Draggable<Map<String, dynamic>>(
        data: {
          'plannedSession': plannedSession,
          'actualSession': actualSession,
        },
        feedback: Material(
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: color.withOpacity(0.7),
            ),
            child: Text(
              (actualSession ?? plannedSession).trainingSessionName,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        childWhenDragging: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.grey.withOpacity(0.3),
          ),
          child: Text(
            (actualSession ?? plannedSession).trainingSessionName,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: color,
          ),
          child: Text(
            (actualSession ?? plannedSession).trainingSessionName
          ),
        ),
      );
    }

    // Add planned-unplanned pairs
    for (var entry in plannedSessions.entries) {
      sessionRows.add(
        Row(
          children: [
            Expanded(
              child: buildPlanningSessionTile(
                entry.key,
                entry.value,
                trainingSessionProvider,
                Colors.green,
              ),
            ),
            if (entry.value != null)
              Expanded(
                child: buildPlanningSessionTile(
                  entry.key,
                  entry.value,
                  trainingSessionProvider,
                  Colors.grey,
                ),
              ),
          ],
        )
      );
    }

    // Add unpaired unplanned sessions
    for (var session in unpaired) {
      sessionRows.add(
        Row(
          children: [
            Expanded(
              child: buildPlanningSessionTile(
                null,
                session,
                trainingSessionProvider,
                Colors.grey,
              ),
            ),
          ],
        )
      );
    }

    return sessionRows;
  }
}