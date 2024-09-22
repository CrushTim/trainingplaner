import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';

class TrainingCycleProvider extends ChangeNotifier {
  //report task to get the training cycles from the database
  //accesable to be mocked in the test
  ///TODO: implement the report task

  ///the selected training cycle
  ///is null if no training cycle is selected
  TrainingCycleBus? _selectedTrainingCycle;

  ///the cycle that is used for addition of new training cycles
  TrainingCycleBus trainingCycleForAdd = TrainingCycleBus(
      trainingCycleID: "",
      cycleName: "",
      description: "",
      emphasis: "",
      userID: "",
      beginDate: DateTime.now(),
      endDate: DateTime.now());

  ///the list of training cycles
  List<TrainingCycleBus> trainingCycles = [];

  // //////////////////////////////////////////////////////////////
  //                              Setter                         //
  // //////////////////////////////////////////////////////////////

  ///set the selected training cycle
  void setSelectedTrainingCycle(TrainingCycleBus? trainingCycle,
      {bool notify = true}) {
    _selectedTrainingCycle = trainingCycle;
    if (notify) {
      notifyListeners();
    }
  }

  void setTrainingCycleForAdd(TrainingCycleBus trainingCycle,
      {bool notify = true}) {
    trainingCycleForAdd = trainingCycle;
    if (notify) {
      notifyListeners();
    }
  }

  // //////////////////////////////////////////////////////////////
  //                Resetters                                   //
  // //////////////////////////////////////////////////////////////

  ///reset the training cycle for addition
  void resetTriningCycleForAdd() {
    trainingCycleForAdd.reset();
  }

  ///reset the selected training cycle
  void resetSelectedTrainingCycle() {
    _selectedTrainingCycle = null;
  }

  // //////////////////////////////////////////////////////////////
  //                Getters                                      //
  // //////////////////////////////////////////////////////////////

  ///get the selected training cycle
  TrainingCycleBus? get getSelectedTrainingCycle {
    return _selectedTrainingCycle;
  }

  ///get the training cycles of the user
  List<TrainingCycleBus> get getTrainingCycles {
    return trainingCycles;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                             //
  // //////////////////////////////////////////////////////////////

  ///add a training cycle to the database
  /// params: ScaffoldMessenger to show snackbar with addition result
  /// returns: Future<void> with the result of the addition
  Future<void> addTrainingCycle(ScaffoldMessengerState scaffoldMessenger,
      {bool notify = true}) async {
    String result = "Added ${trainingCycleForAdd.cycleName}";

    try {
      await trainingCycleForAdd
          .addTrainingCycle()
          .onError((error, stackTrace) => result = error.toString());
    } catch (e) {
      result = e.toString();
    } finally {
      resetTriningCycleForAdd();
      if (notify) {
        notifyListeners();
      }
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(result)));
    }
  }

  ///update a training cycle in the database
  /// params: ScaffoldMessenger to show snackbar with update result
  /// returns: Future<void> with the result of the update
  Future<void> updateTrainingCycle(ScaffoldMessengerState scaffoldMessenger,
      {bool notify = true}) async {
    String result = "Updated ${_selectedTrainingCycle?.cycleName}";

    try {
      await _selectedTrainingCycle!
          .updateTrainingCycle()
          .onError((error, stackTrace) => result = error.toString());
    } catch (e) {
      result = e.toString();
    } finally {
      resetSelectedTrainingCycle();
      if (notify) {
        notifyListeners();
      }
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(result)));
    }
  }

  ///delete a training cycle from the database
  /// params: ScaffoldMessenger to show snackbar with deletion result
  /// returns: Future<void> with the result of the deletion
  Future<void> deleteTrainingCycle(ScaffoldMessengerState scaffoldMessenger,
      {bool notify = true}) async {
    String result = "Deleted ${_selectedTrainingCycle?.cycleName}";

    try {
      await _selectedTrainingCycle!
          .deleteTrainingCycle()
          .onError((error, stackTrace) => result = error.toString());
    } catch (e) {
      result = e.toString();
    } finally {
      resetSelectedTrainingCycle();
      if (notify) {
        notifyListeners();
      }
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(result)));
    }
  }
}
