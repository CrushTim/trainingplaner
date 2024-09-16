import 'package:flutter/material.dart';

class CycleDraggable extends StatelessWidget {
  final int index;
  const CycleDraggable({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                shape: BoxShape.rectangle,
                color: Colors.blue,
              ),
              child: Text("Cycle $index"),
            ),
          ),
          Flexible(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          ),
          Flexible(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                //TODO delete the cycle
              },
            ),
          ),
        ],
      ),
      feedback: Text("Drag me!"),
      childWhenDragging: Text("I'm being dragged!"),
      onDragEnd: (details) {
        print(details.offset);
        //TODO update the list
      },
    );
  }
}
