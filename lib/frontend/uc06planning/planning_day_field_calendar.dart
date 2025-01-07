import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:trainingplaner/frontend/uc05Overview/overview_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/add_planning_session_dialog.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';


class PlanningDayFieldCalendar extends StatelessWidget {
  final DateTime date;
  final List workouts;
  final VoidCallback onAddPressed;
  
  const PlanningDayFieldCalendar({
    super.key,
    required this.workouts,
    required this.date,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    TrainingSessionProvider trainingSessionProvider = Provider.of<TrainingSessionProvider>(context);
    OverviewProvider overviewProvider = Provider.of<OverviewProvider>(context);
    PlanningProvider planningProvider = Provider.of<PlanningProvider>(context);
    // Get planned and unplanned sessions
    Map<dynamic, dynamic> plannedSessions = overviewProvider.separatePlannedAndUnplannedSessions(workouts);
    List unplannedSessions = workouts.where((w) => !w.isPlanned).toList();
    List unpaired = overviewProvider.getUnpairedSessions(unplannedSessions, plannedSessions);

    // Build session rows
    List<Widget> sessionRows = overviewProvider.buildPlanningSessionRows(
      context,
      plannedSessions,
      unpaired,
      trainingSessionProvider,
      date,
    );

    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        shape: BoxShape.rectangle,
        color: Colors.red,
      ),
      child: DragTarget<Map<String, dynamic>>(
        onAcceptWithDetails: (details) async {
          final data = details.data;
          final plannedSession = data['plannedSession'];
          
          try {
            await planningProvider.copySessionToDate(
              plannedSession,
              date,
              ScaffoldMessenger.of(context),
            );
          } catch (e) {
            // Error is already handled in provider
          }
        },
        builder: (context, candidateData, rejectedData) {
          return Column(
            children: [
              Text(
                "${date.day}.${date.month}",
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              ...sessionRows.map((row) {
                if (row is Row) {
                  return Row(
                    children: row.children.map((child) {
                      if (child is Expanded && child.child is Draggable) {
                        return Expanded(
                          child: GestureDetector(
                            onDoubleTap: () {
                              final data = (child.child as Draggable).data as Map<String, dynamic>;
                              final session = data['plannedSession'];
                              final RenderBox button = context.findRenderObject() as RenderBox;
                              final Offset localOffset = button.localToGlobal(Offset.zero);
                              showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                  localOffset.dx,
                                  localOffset.dy,
                                  localOffset.dx + button.size.width,
                                  localOffset.dy + button.size.height,
                                ),
                                items: [
                                  PopupMenuItem(
                                    child: const Text('Edit'),
                                    onTap: () async {
                                      planningProvider.selectedSessionDate = date;
                                      planningProvider.setSelectedBusinessClass(session, notify: false);
                                      
                                      // Capture context before async gap
                                      final BuildContext dialogContext = context;
                                      await showDialog(
                                        context: dialogContext,
                                        builder: (context) => ChangeNotifierProvider.value(
                                          value: planningProvider,
                                          child: AddPlanningSessionDialog(
                                            initialDate: date,
                                            cycleId: session.trainingCycleId,
                                          ),
                                        ),
                                      ).then((value) {
                                        if (value == null || value != true) {
                                          for (var exercise in planningProvider.exercisesToDeleteIfSessionAddIsCancelled) {
                                            trainingSessionProvider.exerciseProvider.deleteBusinessClass(
                                              exercise, 
                                              ScaffoldMessenger.of(dialogContext), 
                                              notify: false
                                            );
                                          }
                                        }
                                        planningProvider.exercisesToDeleteIfSessionAddIsCancelled.clear();
                                      });

                                      // Reset everything after dialog closes
                                      planningProvider.resetSelectedBusinessClass();
                                      planningProvider.resetSessionControllers();
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Delete'),
                                    onTap: () {
                                      trainingSessionProvider.deleteBusinessClass(session, ScaffoldMessenger.of(context), notify: false);
                                    },
                                  ),
                                ],
                              );
                            },
                            child: LongPressDraggable<Map<String, dynamic>>(
                              data: (child.child as Draggable).data as Map<String, dynamic>?,
                              feedback: (child.child as Draggable).feedback,
                              childWhenDragging: (child.child as Draggable).childWhenDragging,
                              child: (child.child as Draggable).child,
                            ),
                          ),
                        );
                      }
                      return child;
                    }).toList(),
                  );
                }
                return row;
              }),
              IconButton(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add),
              ),
            ],
          );
        },
      ),
    );
  }
} 