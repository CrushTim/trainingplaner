import 'package:flutter/material.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/functions/functions_trainingsplaner.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';

class TrainingCycleEditFieldsController {
  final TrainingCycleProvider provider;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emphasisController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  TrainingCycleEditFieldsController(this.provider);

  /// Initialize the state of the controller
  /// Should be called when the state is initialized
  /// @return: void
  void initState() {
    if (provider.getSelectedBusinessClass != null) {
      nameController.text = provider.getSelectedBusinessClass!.cycleName;
      descriptionController.text = provider.getSelectedBusinessClass!.description;
      emphasisController.text = provider.getSelectedBusinessClass!.emphasis.join(', ');
      startDate = provider.getSelectedBusinessClass!.beginDate;
      endDate = provider.getSelectedBusinessClass!.endDate;
      startDateController.text = getDateStringForDisplay(startDate);
      endDateController.text = getDateStringForDisplay(endDate);
    } else {
      nameController.text = provider.businessClassForAdd.cycleName;
      descriptionController.text = provider.businessClassForAdd.description;
      emphasisController.text = provider.businessClassForAdd.emphasis.join(', ');
      startDate = provider.businessClassForAdd.beginDate;
      endDate = provider.businessClassForAdd.endDate;
      startDateController.text = getDateStringForDisplay(startDate);
      endDateController.text = getDateStringForDisplay(endDate);
    }
  }

  /// Handle text field changes
  /// @param field: The field that changed
  /// @param value: The new value
  /// @return: void
  void handleTextFieldChange(String field, String value) {
    TrainingCycleBus target = provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
    switch (field) {
      case 'name':
        target.cycleName = value;
        break;
      case 'description':
        target.description = value;
        break;
      case 'emphasis':
        target.emphasis = value.split(', ');
        break;
    }
  }

  /// Handle start date changes
  /// @param date: The new date
  /// @return: void
  void onStartDateChanged(DateTime date) {
    TrainingCycleBus target = provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
    target.beginDate = date;
    startDate = date;
  }

  /// Handle end date changes
  /// @param date: The new date
  /// @return: void
  void onEndDateChanged(DateTime date) {
    TrainingCycleBus target = provider.getSelectedBusinessClass ?? provider.businessClassForAdd;
    target.endDate = date;
    endDate = date;
  }

  /// Save the training cycle
  /// @param scaffoldMessengerState: The scaffold messenger state
  /// @return: Future<void>
  Future<void> saveTrainingCycle(ScaffoldMessengerState scaffoldMessengerState) async {
    if (provider.getSelectedBusinessClass != null) {
      await provider.updateBusinessClass(provider.getSelectedBusinessClass!, scaffoldMessengerState);
    } else {
      await provider.addBusinessClass(provider.businessClassForAdd, scaffoldMessengerState);
    }
    provider.resetBusinessClassForAdd();
    provider.resetSelectedBusinessClass();
    resetControllers();
  }

  //reset all the controller values to the default values
  void resetControllers() {
    nameController.text = '';
    descriptionController.text = '';
    emphasisController.text = '';
    startDateController.text = getDateStringForDisplay(DateTime.now());
    endDateController.text = getDateStringForDisplay(DateTime.now());
  }

  /// Get the title for the app bar
  /// @return: String
  String getTitle() {
    return provider.getSelectedBusinessClass == null ? "Add Training Cycle" : "Edit Training Cycle";
  }

  /// Dispose the controller
  /// @return: void
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    emphasisController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  /// Gets the current parent value for the dropdown
  /// @return: String?
  String? getCurrentParentValue() {
    return provider.getSelectedBusinessClass == null 
      ? provider.businessClassForAdd.parent 
      : provider.getSelectedBusinessClass?.parent;
  }

  /// Gets the list of dropdown items for parent cycles
  /// @return: List<DropdownMenuItem<String>>
  List<DropdownMenuItem<String>> getParentDropdownItems() {
    return [
      const DropdownMenuItem<String>(
        value: null,
        child: Text('No Parent'),
      ),
      ...provider.businessClasses.map((cycle) => DropdownMenuItem<String>(
        value: cycle.getId(),
        child: Text(cycle.cycleName),
      )),
    ];
  }

  /// Updates the parent cycle
  /// @param value: The new parent cycle ID
  /// @return: void
  void updateParent(String? value) {
    if (provider.getSelectedBusinessClass != null) {
      provider.getSelectedBusinessClass!.parent = value;
    } else {
      provider.businessClassForAdd.parent = value;
    }
  }
} 