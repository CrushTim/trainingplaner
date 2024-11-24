import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/firebase_options.dart';
import 'package:trainingplaner/frontend/home_page.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:trainingplaner/frontend/uc02TrainingSession/training_session_provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fireabase_ui_auth;
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';
import 'package:trainingplaner/frontend/uc05Overview/overview_provider.dart';
import 'package:trainingplaner/frontend/uc06planning/planning_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final providers = [
      fireabase_ui_auth.EmailAuthProvider(),
    ];

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
      initialRoute:
          FirebaseAuth.instance.currentUser != null ? '/home' : '/login',
      routes: {
        '/login': (context) => fireabase_ui_auth.SignInScreen(
              providers: providers,
              actions: [
                fireabase_ui_auth.AuthStateChangeAction<
                    fireabase_ui_auth.SignedIn>((context, state) {
                  Navigator.of(context).pushReplacementNamed('/home');
                })
              ],
            ),
        '/home': (context) => MultiProvider(providers: [
              ChangeNotifierProvider(
                  create: (context) => TrainingSessionProvider()),
              ChangeNotifierProvider(
                  create: (context) => TrainingCycleProvider()),
              ChangeNotifierProvider(
                  create: (context) => ExerciseFoundationProvider()),
              ChangeNotifierProvider(create: (context) => OverviewProvider()),
              ChangeNotifierProvider(create: (context) => PlanningProvider()),
            ], child: const HomePage()),
      },
    );
  }
}

