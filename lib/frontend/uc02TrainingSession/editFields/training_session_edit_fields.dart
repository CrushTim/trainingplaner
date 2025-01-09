import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/costum_widgets/date_picker_sheer.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/editFields/training_session_edit_fields_controller.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

class TrainingSessionEditFields extends StatelessWidget {

  const TrainingSessionEditFields({
    super.key,
    this.worksOnActual = false,
  });

  final bool worksOnActual;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrainingSessionProvider>(context);
    TrainingSessionEditFieldsController controller = TrainingSessionEditFieldsController(provider, worksOnActual: worksOnActual);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller:  controller.sessionNameController,
          decoration: const InputDecoration(labelText: 'Session Name'),
          onChanged: (value) => controller.handleSessionFieldChange('name', value),
        ),
        TextField(
          controller: controller.sessionDescriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
          onChanged: (value) => controller.handleSessionFieldChange('description', value),
        ),
        TextField(
          controller: controller.sessionEmphasisController,
          decoration: const InputDecoration(labelText: 'Emphasis (comma separated)'),
          onChanged: (value) => controller.handleSessionFieldChange('emphasis', value),
        ),
        TextField(
          controller: controller.sessionLengthController,
          decoration: const InputDecoration(labelText: 'Length (minutes)'),
          keyboardType: TextInputType.number,
          onChanged: (value) => controller.handleSessionFieldChange('length', value),
        ),
        DropdownButtonFormField<String>(
          value: controller.getCurrentParentValue(),
          decoration: const InputDecoration(labelText: 'Parent Cycle'),
          items: controller.getParentDropdownItems(),
          onChanged: controller.updateParent,
        ),
        DatePickerSheer(
          initialDateTime: provider.selectedSessionDate,
          onDateTimeChanged: controller.updateSessionDate,
          dateController: controller.sessionDateController,
        ),
      ],
    );
  }
} 