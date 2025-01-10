import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/dialog/add_session_dialog_controller.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/editFields/training_session_edit_fields.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class AddSessionDialog extends StatefulWidget {
  const AddSessionDialog({super.key});

  @override
  State<AddSessionDialog> createState() => _AddSessionDialogState();
}

class _AddSessionDialogState extends State<AddSessionDialog> {
  late AddSessionDialogController controller;

  @override
  void initState() {
    super.initState();
    controller = AddSessionDialogController(
      Provider.of<TrainingSessionProvider>(context, listen: false)
    );
    controller.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TrainingSessionEditFields(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.saveSession(
                  context,
                  ScaffoldMessenger.of(context)
                ),
                child: Text(controller.getSaveButtonText()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
