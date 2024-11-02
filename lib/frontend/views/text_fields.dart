
import 'package:flutter/material.dart';

class SheerUpDateTimePickerFields extends TextField {
  const SheerUpDateTimePickerFields(
    controller, {
    super.key,
    hintText = "",
    onChanged,
  }) : super(
          readOnly: true,
          keyboardType: TextInputType.datetime,
          controller: controller,
          onChanged: onChanged,
        );
}