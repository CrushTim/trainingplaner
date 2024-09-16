import 'package:flutter/material.dart';
import 'package:trainingplaner/frontend/uc03TrainingExcercise/reps_weights_row.dart';

class TrainingExcerciseRow extends StatefulWidget {
  const TrainingExcerciseRow({
    super.key,
  });

  @override
  State<TrainingExcerciseRow> createState() => _TrainingExcerciseRowState();
}

class _TrainingExcerciseRowState extends State<TrainingExcerciseRow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        child: isExpanded
            ? Column(
                children: [
                  RepsWeightsRow(),
                  RepsWeightsRow(),
                  RepsWeightsRow(),
                  RepsWeightsRow(),
                  RepsWeightsRow(),
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              //TODO: implement add set
                            },
                            icon: const Icon(Icons.add)),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.arrow_drop_up),
                          onPressed: () {
                            print("Pressed up");
                            //TODO: implement save of the excercise with all sets and reps
                            setState(() {
                              isExpanded = false;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )
            : IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Squat"),
                    ),
                    Flexible(
                      child: VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text("Planned",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("5 x 100kg"),
                            Text("5 x 100kg"),
                            Text("5 x 100kg"),
                            Text("5 x 100kg"),
                            Text("5 x 100kg"),
                          ],
                        )),
                    Flexible(
                      child: VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text("Actual",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("5 x 100kg"),
                            Text("5 x 100kg"),
                            Text("4 x 100kg"),
                          ],
                        )),
                    Flexible(
                      child: VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                print("Pressed delete");
                                //TODO: make delit button work
                              },
                            ),
                          ),
                          Flexible(
                            child: IconButton(
                              icon: Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                print("Pressed");
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                                //TODO:
                                //EXPAND THE ROW TO A COLUMN WITH EVERY SET AND REPS TO MAKE IT SAVABBLE AND EDITABLE TO MAKE IT A DIARY ENTRY
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
