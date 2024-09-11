import 'package:flutter/material.dart';
import 'package:trainingplaner/views/overview_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const OverviewView(),
    );
  }
}
