import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/controllers/training_session_edit_fields_controller.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class AddSessionDialogController {
  final TrainingSessionProvider provider;
  late TrainingSessionEditFieldsController editFieldsController;

  AddSessionDialogController(this.provider) {
    editFieldsController = TrainingSessionEditFieldsController(provider);
  }

  /// Initialize the dialog state
  /// @return: void
  void initState() {
    editFieldsController.initStatForDialog();
  }

  /// Save the session and handle dialog closure
  /// @param context: The build context
  /// @param scaffoldMessengerState: The scaffold messenger state
  /// @return: Future<void>
  Future<void> saveSession(BuildContext context, ScaffoldMessengerState scaffoldMessengerState) async {
    if (provider.getSelectedBusinessClass != null) {
      await provider.updateBusinessClass(
        provider.getSelectedBusinessClass!, 
        scaffoldMessengerState
      );
    } else {
      await provider.addBusinessClass(
        provider.businessClassForAdd, 
        scaffoldMessengerState
      );
    }
    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  /// Get the save button text based on whether we're editing or adding
  /// @return: String
  String getSaveButtonText() {
    return provider.getSelectedBusinessClass != null ? 'Update' : 'Save';
  }

  /// Dispose of the controllers
  /// @return: void
  void dispose() {
    editFieldsController.dispose();
  }
} 