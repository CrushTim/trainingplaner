import 'package:flutter/material.dart';

class EditCyclesView extends StatefulWidget {
  const EditCyclesView({super.key});

  @override
  State<EditCyclesView> createState() => _EditCyclesViewState();
}

class _EditCyclesViewState extends State<EditCyclesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Cycles"),
      ),
      body: ListView(
        children: List<Widget>.generate(3, (index) {
              return CycleDraggable(
                index: index,
              );
            }) +
            [
              ElevatedButton(
                onPressed: () {
                  //TODO add a new cycle
                },
                child: const Text("Add Cycle"),
              ),
            ],
      ),
    );
  }
}

class CycleDraggable extends StatelessWidget {
  final int index;
  const CycleDraggable({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          shape: BoxShape.rectangle,
          color: Colors.blue,
        ),
        child: Text("Cycle $index"),
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
