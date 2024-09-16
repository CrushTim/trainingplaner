import 'package:flutter/material.dart';

class CycleBarCalendar extends StatelessWidget {
  final String title;
  final Color color;
  const CycleBarCalendar({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        shape: BoxShape.rectangle,
        color: color,
      ),
      height: 20,
      width: MediaQuery.of(context).size.width,
      child: Text(
        title,
      ),
    );
  }
}
