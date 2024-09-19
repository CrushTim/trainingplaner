import 'package:flutter/cupertino.dart';
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
  //                Getter and Setter                         //
  // //////////////////////////////////////////////////////////////

  ///set the selected training cycle
  void setSelectedTrainingCycle(TrainingCycleBus? trainingCycle,
      {bool notify = true}) {
    _selectedTrainingCycle = trainingCycle;
    if (notify) {
      notifyListeners();
    }
  }

  // //////////////////////////////////////////////////////////////
  //                Resetters                                   //
  // //////////////////////////////////////////////////////////////

  ///add a new training cycle to the list
  void resetTriningCycleForAdd() {}
}
