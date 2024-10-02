import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/firebase_options.dart';
import 'package:trainingplaner/frontend/home_page.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      )),
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => TrainingSessionProvider()),
        ChangeNotifierProvider(create: (context) => TrainingCycleProvider()),
      ], child: const HomePage()),
    );
  }
}
