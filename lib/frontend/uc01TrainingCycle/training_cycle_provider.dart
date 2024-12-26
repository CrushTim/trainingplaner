import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_exercise_bus.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';
import 'package:trainingplaner/business/reports/trainings_cycle_bus_report.dart';
import 'package:trainingplaner/frontend/costum_widgets/cycle_bar_calendar.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_list_tile.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/training_exercise_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/add_planning_session_dialog.dart';
import 'package:trainingplaner/frontend/uc06planning/cycle_edit_column.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_day_field_calendar.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

class TrainingCycleProvider
    extends TrainingsplanerProvider<TrainingCycleBus, TrainingCycleBusReport> {
  TrainingCycleProvider()
      : super(
            businessClassForAdd: TrainingCycleBus(
                trainingCycleID: "",
                cycleName: "",
                description: "",
                emphasis: [],
                beginDate: DateTime.now(),
                endDate: DateTime.now()),
            reportTaskVar: TrainingCycleBusReport());

  /// Method to retrieve the training cycles to return as draggables and 
  /// to be used in the edit_cycles_view
  Widget getTrainingCycles({bool planningMode = false}) {
    return StreamBuilder<List<TrainingCycleBus>>(
      stream: reportTaskVar.getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No training cycles available'));
        }
        businessClasses = snapshot.data!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: snapshot.data!.map((cycle) => 
            TrainingCycleListTile(
              trainingCycleBus: cycle,
              planningMode: planningMode,
            )
          ).toList(),
        );
      },
    );
  }

  
  // /////////////////////////////////////////////////////////////////////
  //                         EDIT FIELDS LOGIC
  // /////////////////////////////////////////////////////////////////////
  

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emphasisController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String? selectedParentId;

  List<TrainingCycleBus> parentCycles = [];



  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  void initState() {
    if(getSelectedBusinessClass != null) {
      nameController.text = getSelectedBusinessClass!.cycleName;
      descriptionController.text = getSelectedBusinessClass!.description;
      emphasisController.text = getSelectedBusinessClass!.emphasis.join(', ');
      _startDate = getSelectedBusinessClass!.beginDate;
      _endDate = getSelectedBusinessClass!.endDate;
      startDateController.text = getDateStringForDisplay(_startDate);
      endDateController.text = getDateStringForDisplay(_endDate);
    } else {
      nameController.text = businessClassForAdd.cycleName;
      descriptionController.text = businessClassForAdd.description;
      emphasisController.text = businessClassForAdd.emphasis.join(', ');
      _startDate = businessClassForAdd.beginDate;
      _endDate = businessClassForAdd.endDate;
      startDateController.text = getDateStringForDisplay(businessClassForAdd.beginDate);
      endDateController.text = getDateStringForDisplay(businessClassForAdd.endDate);
    }
  }

  void handleTextFieldChange(String field, String value) {
    switch (field) {
      case 'name':
        if (getSelectedBusinessClass != null) {
          getSelectedBusinessClass!.cycleName = value;
        } else {
          businessClassForAdd.cycleName = value;
        }
        break;
      case 'description':
        if (getSelectedBusinessClass != null) {
            getSelectedBusinessClass!.description = value;
        } else {
          businessClassForAdd.description = value;
        }
        break;
      case 'emphasis':
        if (getSelectedBusinessClass != null) {
            getSelectedBusinessClass!.emphasis = [value];
        } else {
          businessClassForAdd.emphasis = [value];
        }
        break;
    }
  }

  void updateStartDate(DateTime date) {
    _startDate = date;
    startDateController.text = getDateStringForDisplay(date);
    if (getSelectedBusinessClass != null) {
      getSelectedBusinessClass!.beginDate = date;
    } else {
      businessClassForAdd.beginDate = date;
    }
    notifyListeners();
  }

  void updateEndDate(DateTime date) {
    _endDate = date;
    endDateController.text = getDateStringForDisplay(date);
    if (getSelectedBusinessClass != null) {
      getSelectedBusinessClass!.endDate = date;
    } else {
      businessClassForAdd.endDate = date;
    }
    notifyListeners();
  }

  void updateParent(String? parentId) {
    selectedParentId = parentId;
    if (getSelectedBusinessClass != null) {
      getSelectedBusinessClass!.parent = parentId;
    } else {
      businessClassForAdd.parent = parentId;
    }
  }

 

  Future<void> saveTrainingCycle(ScaffoldMessengerState scaffoldMessengerState) async {
    if (getSelectedBusinessClass != null) {
      await updateSelectedBusinessClass(scaffoldMessengerState);
    } else {
      await addForAddBusinessClass(scaffoldMessengerState);
    }

    resetBusinessClassForAdd();
    resetSelectedBusinessClass();

    resetControllers();
  }


  void resetControllers() {
    nameController.clear();
    descriptionController.clear();
    emphasisController.clear();
    startDateController.clear();
    endDateController.clear();
  }


  // /////////////////////////////////////////////////////////////////////
  //                         PLANNING LOGIC
  // /////////////////////////////////////////////////////////////////////

  Map<DateTime, List<dynamic>> generateSessionDateMap(TrainingCycleBus cycle) {

    Map<DateTime, List<dynamic>> sessionDateMap = {};
    DateTime startDate = cycle.beginDate;
    DateTime endDate = cycle.endDate;

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

 Map<DateTime, List<dynamic>> mapSessionsToDateMap( List<TrainingSessionBus> sessions) {
    Map<DateTime, List<dynamic>> sessionDateMap = generateSessionDateMap(getSelectedBusinessClass!);
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
    return sessionDateMap;
  }

  void mapExercisesToSessions(List<TrainingExerciseBus> exercises, List<TrainingSessionBus> sessions) {
    for (var exercise in exercises){
      for (var session in sessions){
        if (session.trainingSessionExcercisesIds.contains(exercise.trainingExerciseID)){
          session.trainingSessionExercises.add(exercise);
        }
      }
    }
  }


  StreamBuilder3 getPlanningStreamBuilder(TrainingSessionProvider sessionProvider, TrainingExerciseProvider exerciseProvider, PlanningProvider planningProvider) {
    return StreamBuilder3(
        streams: StreamTuple3(
          sessionProvider.reportTaskVar.getAll(),
          reportTaskVar.getAll(),
          exerciseProvider.reportTaskVar.getAll(),
        ),
        builder: (context, snapshots) {
          if (snapshots.snapshot1.hasError || snapshots.snapshot2.hasError || snapshots.snapshot3.hasError) {
            if (snapshots.snapshot1.hasError) {
              return Text(snapshots.snapshot1.error.toString());
            }
            if (snapshots.snapshot2.hasError) {
              return Text(snapshots.snapshot2.error.toString());
            }
            if (snapshots.snapshot3.hasError) {
              return Text(snapshots.snapshot3.error.toString());
            }
          }
          if (snapshots.snapshot1.connectionState == ConnectionState.waiting ||
              snapshots.snapshot2.connectionState == ConnectionState.waiting ||
              snapshots.snapshot3.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = snapshots.snapshot1.data!.where(
            (session) => session.trainingCycleId == getSelectedBusinessClass!.getId()
          ).toList();

          final cycles = snapshots.snapshot2.data!;
          final childCycles = cycles.where(
            (cycle) => cycle.parent == getSelectedBusinessClass!.getId()
          ).toList();

          final exercises = snapshots.snapshot3.data!.where(
            (TrainingExerciseBus exercise) => exercise.isPlanned
          ).toList();


          planningProvider.getSelectedBusinessClass?.trainingSessionExercises.clear();
          
          for (var session in sessions) {
            session.trainingSessionExercises.clear();
          }
          //map the exercises to the sessions
          mapExercisesToSessions(exercises, sessions);
          Map<DateTime, List<dynamic>> sessionDateMap = mapSessionsToDateMap(sessions);
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
                    children: [
                      ...List.generate(
                        weekMap.entries.elementAt(index).value.length,
                        (dayIndex) {
                          final date = weekMap.entries.elementAt(index).value[dayIndex];
                          return Expanded(
                            child: PlanningDayFieldCalendar(
                              date: date,
                              workouts: sessionDateMap[date] ?? [], onAddPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {   
                                  return ChangeNotifierProvider.value(
                                    value: planningProvider,
                                    child: AddPlanningSessionDialog(
                                    initialDate: date,
                                    cycleId: getSelectedBusinessClass!.getId(),
                                    ),
                                  );
                                },
                              );
                            },
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: CycleEditColumn(
                          weekSessions: weekMap.entries.elementAt(index).value
                              .expand((date) => sessionDateMap[date] ?? [])
                              .toList(),
                          copiedWeek: index,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          );
        },
      );
  }

}
