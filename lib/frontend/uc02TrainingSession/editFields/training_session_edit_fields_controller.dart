import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class TrainingSessionEditFieldsController {
  final TrainingSessionProvider provider;
  final bool worksOnActual;

  final TextEditingController sessionNameController = TextEditingController();
  final TextEditingController sessionDescriptionController = TextEditingController();
  final TextEditingController sessionEmphasisController = TextEditingController();
  final TextEditingController sessionLengthController = TextEditingController();
  final TextEditingController sessionDateController = TextEditingController();

  TrainingSessionEditFieldsController(this.provider, {this.worksOnActual = false}) {
    // Initialize controllers when the class is instantiated
    initState();
  }

  void initState() {
    if (worksOnActual && provider.selectedActualSession != null) {
      final session = provider.selectedActualSession!;
      sessionNameController.text = session.trainingSessionName;
      sessionDescriptionController.text = session.trainingSessionDescription;
      sessionEmphasisController.text = session.trainingSessionEmphasis.join(', ');
      sessionLengthController.text = session.trainingSessionLength.toString();
      sessionDateController.text = session.trainingSessionStartDate.toString();
      provider.selectedSessionDate = session.trainingSessionStartDate;
    } else if (!worksOnActual) {
      // For adding new sessions
      resetSessionControllers();
    }
  }

  void handleSessionFieldChange(String field, String value) {
    if (worksOnActual) {
      handleSessionFieldChangeForActual(field, value);
    } else {
      handleSessionFieldChangeForAdd(field, value);
    }
  }

  String? getCurrentParentValue() {
    if (worksOnActual) {
      return provider.selectedActualSession?.trainingCycleId.isEmpty == true ? 
        null : provider.selectedActualSession?.trainingCycleId;
    } else {
      return provider.businessClassForAdd.trainingCycleId.isEmpty ? 
        null : provider.businessClassForAdd.trainingCycleId;
    }
  }

  void updateParent(String? value) {
    final cycleId = value ?? '';
    if (worksOnActual) {
      handleSessionFieldChangeForActual('cycle', cycleId);
    } else {
      handleSessionFieldChangeForAdd('cycle', cycleId);
    }
  }

  List<DropdownMenuItem<String>> getParentDropdownItems() {
    return [
      const DropdownMenuItem<String>(
        value: null,
        child: Text('No Parent'),
      ),
      ...provider.allCycles.map((cycle) => DropdownMenuItem<String>(
        value: cycle.getId(),
        child: Text(cycle.cycleName),
      )),
    ];
  }

  void updateSessionDate(DateTime date) {
    provider.selectedSessionDate = date;
    final target = provider.selectedActualSession ?? provider.businessClassForAdd;
    target.trainingSessionStartDate = date;
    print(target.trainingSessionStartDate);
    print("selectedSessionDate: $provider.selectedSessionDate");
  }

  //method to reset the session controllers
  ///is used to reset the session controllers after a new selection of a session or exercise
  void resetSessionControllers() {
    sessionNameController.clear();
    sessionDescriptionController.clear();
    sessionEmphasisController.clear();
    sessionLengthController.text = "60";
    provider.selectedSessionDate = DateTime.now();
  }

   void initControllersForPlanningView() {
    final target = provider.getSelectedBusinessClass;
    if (target != null) {
      sessionNameController.text = target.trainingSessionName;
      sessionDescriptionController.text = target.trainingSessionDescription;
      sessionEmphasisController.text = target.trainingSessionEmphasis.join(', ');
      sessionLengthController.text = target.trainingSessionLength.toString();
      provider.selectedSessionDate = target.trainingSessionStartDate;
    } else {
      sessionNameController.clear();
      sessionDescriptionController.clear();
      sessionEmphasisController.clear();
      sessionLengthController.text = "60";
      provider.selectedSessionDate = DateTime.now();
    }
  }

  

  void handleSessionFieldChangeForAdd(String field, String value) {
    final target = provider.businessClassForAdd;
    switch (field) {
      case 'name':
        target.trainingSessionName = value;
        break;
      case 'description':
        target.trainingSessionDescription = value;
        break;
      case 'emphasis':
        target.trainingSessionEmphasis = value.split(',').map((e) => e.trim()).toList();
        break;
      case 'length':
        target.trainingSessionLength = int.tryParse(value) ?? 60;
        break;
      case 'cycle':
        target.trainingCycleId = value;
        break;
    }
  }

  

  void handleSessionFieldChangeForActual(String field, String value) {
    final target = provider.selectedActualSession ?? provider.businessClassForAdd;
    switch (field) {
      case 'name':
        target.trainingSessionName = value;
        break;
      case 'description':
        target.trainingSessionDescription = value;
        break;
      case 'emphasis':
        target.trainingSessionEmphasis = value.split(',').map((e) => e.trim()).toList();
        break;
      case 'length':
        target.trainingSessionLength = int.tryParse(value) ?? 60;
        break;
      case 'cycle':
        target.trainingCycleId = value;
        break;
      case 'date':
        target.trainingSessionStartDate = DateTime.parse(value);
        provider.selectedSessionDate = target.trainingSessionStartDate;
        break;
    }
  } 

 void initStatForDialog(){
    resetSessionControllers();
    provider.resetBusinessClassForAdd();
  }

  void dispose() {
    sessionNameController.dispose();
    sessionDescriptionController.dispose();
    sessionEmphasisController.dispose();
    sessionLengthController.dispose();
    sessionDateController.dispose();
  }



} 