import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_session_bus.dart';

class TrainingSessionProvider extends ChangeNotifier {
  //report task to get the training sessions from the database
  //accesable to be mocked in the test
  //TODO: implement the report task

  ///the selected training session
  ///is null if no training session is selected
  TrainingSessionBus? _selectedTrainingSession;

  ///the session that is used for addition of new training sessions
  TrainingSessionBus trainingSessionForAdd = TrainingSessionBus(
      trainingSessionId: "",
      isPlanned: true,
      trainingSessionName: "",
      trainingSessionDescription: "",
      trainingSessionEmphasis: "",
      trainingSessionExcercises: [],
      trainingSessionLength: 1,
      trainingSessionStartDate: DateTime.now(),
      trainingCycleId: "");

  ///the list of training sessions
  List<TrainingSessionBus> trainingSessions = [];

  // //////////////////////////////////////////////////////////////
  //                              Setter                         //
  // //////////////////////////////////////////////////////////////

  ///set the selected training session
  ///if notify is true the listeners are notified
  void setSelectedTrainingSession(TrainingSessionBus? trainingSession,
      {bool notify = true}) {
    _selectedTrainingSession = trainingSession;
    if (notify) {
      notifyListeners();
    }
  }

  ///set the training session for addition
  ///if notify is true the listeners are notified
  void setTrainingSessionForAdd(TrainingSessionBus trainingSession,
      {bool notify = true}) {
    trainingSessionForAdd = trainingSession;
    if (notify) {
      notifyListeners();
    }
  }

  // //////////////////////////////////////////////////////////////
  //                Resetters                                   //
  // //////////////////////////////////////////////////////////////

  ///reset the training session for addition
  void resetTrainingSessionForAdd() {
    trainingSessionForAdd.reset();
  }

  ///reset the selected training session
  void resetSelectedTrainingSession() {
    _selectedTrainingSession = null;
  }

  // //////////////////////////////////////////////////////////////
  //                Getters                                      //
  // //////////////////////////////////////////////////////////////

  ///get the selected training session
  ///returns null if no training session is selected
  TrainingSessionBus? get getSelectedTrainingSession {
    return _selectedTrainingSession;
  }

  ///get the training sessions of the user
  List<TrainingSessionBus> get getTrainingSessions {
    return trainingSessions;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                             //
  // //////////////////////////////////////////////////////////////

  ///add a training session to the database
  /// params: ScaffoldMessenger to show snackbar with addition result
  ///         notify: if true the listeners are notified
  /// returns: Future<void> with the result of the addition
  //Future.error(Exception(e)) is used to return an error to the caller

  Future<void> addTrainingSession(ScaffoldMessengerState scaffoldMessenger,
      {bool notify = true}) async {
    String result = "Added ${trainingSessionForAdd.trainingSessionName}";

    try {
      await trainingSessionForAdd
          .addTrainingSession()
          .onError((error, stackTrace) => result = error.toString());
    } catch (e) {
      result = e.toString();
    } finally {
      resetTrainingSessionForAdd();
      if (notify) {
        notifyListeners();
      }
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(result)));
    }
  }

  ///update a training session in the database
  /// params: ScaffoldMessenger to show snackbar with update result
  ///        notify: if true the listeners are notified
  /// returns: Future<void> with the result of the update
  /// throws: Exception if the update fails
  Future<void> updateTrainingSession(ScaffoldMessengerState scaffoldMessenger,
      {bool notify = true}) async {
    String result = "Updated ${_selectedTrainingSession!.trainingSessionName}";

    try {
      await _selectedTrainingSession!
          .updateTrainingSession()
          .onError((error, stackTrace) => result = error.toString());
    } catch (e) {
      result = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(result)));
    }
  }

  ///delete a training session from the database
  /// params: ScaffoldMessenger to show snackbar with deletion result
  ///       notify: if true the listeners are notified
  /// returns: Future<void> with the result of the deletion
  /// throws: Exception if the deletion fails
  Future<void> deleteTrainingSession(ScaffoldMessengerState scaffoldMessenger,
      {bool notify = true}) async {
    String result = "Deleted ${_selectedTrainingSession!.trainingSessionName}";

    try {
      await _selectedTrainingSession!
          .deleteTrainingSession()
          .onError((error, stackTrace) => result = error.toString());
    } catch (e) {
      result = e.toString();
    } finally {
      resetSelectedTrainingSession();
      if (notify) {
        notifyListeners();
      }
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(result)));
    }
  }
}
