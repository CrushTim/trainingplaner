import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/business/reports/trainings_cycle_bus_report.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_list_tile.dart';

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
  Widget getTrainingCycles() {
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
          children: snapshot.data!.map((cycle) => 
            TrainingCycleListTile(trainingCycleBus: cycle)
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

  void fetchParentCycles() {
    //show a selectable drop down menu with the parent cycles 


  }
  
  void resetControllers() {
    nameController.clear();
    descriptionController.clear();
    emphasisController.clear();
    startDateController.clear();
    endDateController.clear();
  }
}
