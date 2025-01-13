abstract class DayFieldBaseController {
  /// Separates planned and unplanned sessions into a map
  /// where planned sessions are keys and their corresponding unplanned sessions are values
  /// @param workouts: List of workout sessions
  /// @return: Map with planned sessions as keys and matched unplanned sessions as values
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

  /// Gets a list of unplanned sessions that are not paired with any planned session
  /// @param unplannedSessions: List of all unplanned sessions
  /// @param plannedSessions: Map of planned sessions and their pairs
  /// @return: List of unpaired unplanned sessions
  List getUnpairedSessions(List unplannedSessions, Map<dynamic, dynamic> plannedSessions) {
    return unplannedSessions.where((session) => 
      !plannedSessions.values.contains(session) && 
      session.plannedSessionId == null
    ).toList();
  }

  /// Gets all unplanned sessions from a list of workouts
  /// @param workouts: List of workout sessions
  /// @return: List of unplanned sessions
  List getUnplannedSessions(List workouts) {
    return workouts.where((w) => !w.isPlanned).toList();
  }
}