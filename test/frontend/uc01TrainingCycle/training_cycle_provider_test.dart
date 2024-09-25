import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';

import 'training_cycle_provider_test.mocks.dart';

//class MockTrainingCycleBus extends Mock implements TrainingCycleBus {}
@GenerateNiceMocks([
  MockSpec<TrainingCycleBus>(),
])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TrainingCycleProvider provider;
  late MockTrainingCycleBus mockTrainingCycleBus;

  setUp(() {
    mockTrainingCycleBus = MockTrainingCycleBus();
    provider = TrainingCycleProvider();
  });

  // //////////////////////////////////////////////////////////////
  //                              Setter                         //
  // //////////////////////////////////////////////////////////////
  group("setSelectedTrainingCycle", () {
    test("should set the selected training cycle", () {
      //act
      provider.setSelectedTrainingCycle(mockTrainingCycleBus);

      //assert
      expect(provider.getSelectedTrainingCycle, mockTrainingCycleBus);
    });

    test("should notify listeners", () {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      //act
      provider.setSelectedTrainingCycle(mockTrainingCycleBus);

      //assert
      expect(listenerCalled, true);
    });

    test("should not notify listeners", () {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      //act
      provider.setSelectedTrainingCycle(mockTrainingCycleBus, notify: false);

      //assert
      expect(listenerCalled, false);
    });
  });

  // //////////////////////////////////////////////////////////////
  //                              Resetters                      //
  // //////////////////////////////////////////////////////////////

  group("resetTriningCycleForAdd", () {
    test("should reset the training cycle for addition", () {
      //arrange
      provider.trainingCycleForAdd = mockTrainingCycleBus;

      //act
      provider.resetTriningCycleForAdd();

      //assert
      verify(mockTrainingCycleBus.reset()).called(1);
    });
  });

  group("resetSelectedTrainingCycle", () {
    test("should reset the selected training cycle", () {
      //arrange
      provider.setSelectedTrainingCycle(mockTrainingCycleBus);

      //act
      provider.resetSelectedTrainingCycle();

      //assert
      expect(provider.getSelectedTrainingCycle, null);
    });
  });

  // //////////////////////////////////////////////////////////////
  //                              Crud-Function                  //
  // //////////////////////////////////////////////////////////////

  group("addTrainingCycle", () {
    testWidgets("positive - should add a training cycle",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setTrainingCycleForAdd(mockTrainingCycleBus, notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.addTrainingCycle(
                  ScaffoldMessenger.of(tester.element(find.byType(Scaffold))));
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(
          find.text("Added ${mockTrainingCycleBus.cycleName}"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingCycleBus.add()).called(1);
      verify(mockTrainingCycleBus.reset()).called(1);
    });

    testWidgets("positive - with notify false", (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setTrainingCycleForAdd(mockTrainingCycleBus, notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.addTrainingCycle(
                  ScaffoldMessenger.of(tester.element(find.byType(Scaffold))),
                  notify: false);
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(listenerCalled, false);
    });

    testWidgets("negative - future error", (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setTrainingCycleForAdd(mockTrainingCycleBus);

      when(mockTrainingCycleBus.add()).thenAnswer((_) => Future.error("error"));

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.addTrainingCycle(
                  ScaffoldMessenger.of(tester.element(find.byType(Scaffold))),
                  notify: false);
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(find.text("error"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingCycleBus.add()).called(1);
      verify(mockTrainingCycleBus.reset()).called(1);
    });

    testWidgets("negative - catch error", (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setTrainingCycleForAdd(mockTrainingCycleBus, notify: false);

      when(mockTrainingCycleBus.add()).thenThrow("error");

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.addTrainingCycle(
                  ScaffoldMessenger.of(tester.element(find.byType(Scaffold))));
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(find.text("error"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingCycleBus.add()).called(1);
      verify(mockTrainingCycleBus.reset()).called(1);
    });
  });

  group("updateTrainingCycle", () {
    testWidgets("positive - should update a training cycle",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedTrainingCycle(mockTrainingCycleBus, notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.updateTrainingCycle(
                  ScaffoldMessenger.of(tester.element(find.byType(Scaffold))));
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      print(find.text("Updated ${mockTrainingCycleBus.cycleName}"));
      //assert
      expect(find.text("Updated ${mockTrainingCycleBus.cycleName}"),
          findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingCycleBus.update()).called(1);
      expect(provider.getSelectedTrainingCycle, null);
    });

    testWidgets("positive - with notify false", (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedTrainingCycle(mockTrainingCycleBus, notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.updateTrainingCycle(
                  ScaffoldMessenger.of(
                    tester.element(find.byType(Scaffold)),
                  ),
                  notify: false);
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(listenerCalled, false);
    });

    testWidgets("negative - future error", (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedTrainingCycle(mockTrainingCycleBus);

      when(mockTrainingCycleBus.update())
          .thenAnswer((_) => Future.error("error"));

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.updateTrainingCycle(
                  ScaffoldMessenger.of(
                    tester.element(find.byType(Scaffold)),
                  ),
                  notify: false);
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(find.text("error"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingCycleBus.update()).called(1);
      expect(provider.getSelectedTrainingCycle, null);
    });

    testWidgets("negative - Exception error", (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedTrainingCycle(mockTrainingCycleBus);

      when(mockTrainingCycleBus.update()).thenThrow("error");

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.updateTrainingCycle(
                  ScaffoldMessenger.of(tester.element(find.byType(Scaffold))),
                  notify: false);
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(find.text("error"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingCycleBus.update()).called(1);
      expect(provider.getSelectedTrainingCycle, null);
    });
  });

  group("deleteTrainingCycle", () {
    testWidgets("positive - should delete a training cycle",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedTrainingCycle(mockTrainingCycleBus);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.deleteTrainingCycle(
                  ScaffoldMessenger.of(
                    tester.element(find.byType(Scaffold)),
                  ),
                  notify: false);
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(find.text("Deleted ${mockTrainingCycleBus.cycleName}"),
          findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingCycleBus.delete()).called(1);
      expect(provider.getSelectedTrainingCycle, null);
    });

    testWidgets("positive - with notify false", (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedTrainingCycle(mockTrainingCycleBus, notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.deleteTrainingCycle(
                  ScaffoldMessenger.of(
                    tester.element(find.byType(Scaffold)),
                  ),
                  notify: false);
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(listenerCalled, false);
    });

    testWidgets("negative - future error", (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedTrainingCycle(mockTrainingCycleBus);

      when(mockTrainingCycleBus.delete())
          .thenAnswer((_) => Future.error("error"));

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.deleteTrainingCycle(
                  ScaffoldMessenger.of(
                    tester.element(find.byType(Scaffold)),
                  ),
                  notify: false);
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(find.text("error"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingCycleBus.delete()).called(1);
      expect(provider.getSelectedTrainingCycle, null);
    });

    testWidgets("negative - Exception error", (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedTrainingCycle(mockTrainingCycleBus);

      when(mockTrainingCycleBus.delete()).thenThrow("error");

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.deleteTrainingCycle(
                  ScaffoldMessenger.of(tester.element(find.byType(Scaffold))),
                  notify: false);
            },
            child: const Text("test"),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      //assert
      expect(find.text("error"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingCycleBus.delete()).called(1);
      expect(provider.getSelectedTrainingCycle, null);
    });
  });
}
