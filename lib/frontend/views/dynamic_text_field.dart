import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/views/text_fields.dart';
//a textfield, that changes its width based on the text inside
class DynamicTextField extends StatefulWidget {
  final TextEditingController controller;
  const DynamicTextField({super.key, required this.controller});

  @override
  State<DynamicTextField> createState() => _DynamicTextFieldState();
}

class _DynamicTextFieldState extends State<DynamicTextField> {
  late TextEditingController _controller;
  double _width = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {

    // Function to calculate the width of the text
    double calculateWidth(String text, double maxWidth) {
      // Create a TextPainter to measure the text size
      TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: text,),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Return the text width or the max width, whichever is smaller
      return textPainter.width > maxWidth ? maxWidth : textPainter.width;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _width = calculateWidth(_controller.text, constraints.maxWidth) + 10;
        return SizedBox(
          width: _width,
          child: SheerUpDateTimePickerFields(
            _controller,
            onChanged: (value) {
              setState(() {
                _width = calculateWidth(value, constraints.maxWidth);
              });
            },
          ),
        );
      },
    );
  }
}
