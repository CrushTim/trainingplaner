import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';

import 'tester.dart';
import 'trainingsplaner_provider_test.mocks.dart';

class MockTrainingsplanerBusInterfaceImpl
    extends MockTrainingsplanerBusInterface<Tester>
    implements TrainingsplanerBusInterface<Tester> {}

class MockTrainingsplanerBusReportInterfaceImpl
    implements TrainingsplanerBusReportInterface {
  @override
  Stream<List> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
}

//class MockTrainingsplanerBusInterface extends Mock implements TrainingsplanerBusInterface<MockTrainingsplanerBusInterface> {}
@GenerateNiceMocks([MockSpec<TrainingsplanerBusInterface>()])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TrainingsplanerProvider<TrainingsplanerBusInterface<Tester>,
      TrainingsplanerBusReportInterface> provider;

  late MockTrainingsplanerBusInterfaceImpl mockTrainingsplanerBusInterface;

  setUp(
    () {
      mockTrainingsplanerBusInterface = MockTrainingsplanerBusInterfaceImpl();
      provider = TrainingsplanerProvider<TrainingsplanerBusInterface<Tester>,
          TrainingsplanerBusReportInterface>(
        businessClassForAdd: mockTrainingsplanerBusInterface,
        reportTaskVar: MockTrainingsplanerBusReportInterfaceImpl(),
      );
    },
  );
  group("add", () {
    testWidgets("positive - should add a training cycle",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setBusinessClassForAdd(mockTrainingsplanerBusInterface,
          notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.addBusinessClass(
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
      expect(find.text("Added ${mockTrainingsplanerBusInterface.getName()}"),
          findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingsplanerBusInterface.add()).called(1);
      verify(mockTrainingsplanerBusInterface.reset()).called(1);
    });
    testWidgets(
        "positive - should add a training cycle without notifying listeners",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setBusinessClassForAdd(mockTrainingsplanerBusInterface,
          notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.addBusinessClass(
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
      expect(find.text("Added ${mockTrainingsplanerBusInterface.getName()}"),
          findsOneWidget);
      expect(listenerCalled, false);
      verify(mockTrainingsplanerBusInterface.add()).called(1);
      verify(mockTrainingsplanerBusInterface.reset()).called(1);
    });

    testWidgets("negative - should show error when method throws error",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setBusinessClassForAdd(mockTrainingsplanerBusInterface,
          notify: false);

      when(mockTrainingsplanerBusInterface.add()).thenThrow("Error");

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.addBusinessClass(
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
      expect(find.text("Error"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingsplanerBusInterface.add()).called(1);
      verify(mockTrainingsplanerBusInterface.reset()).called(1);
    });

    testWidgets("negative - should show error when method future.error",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setBusinessClassForAdd(mockTrainingsplanerBusInterface,
          notify: false);

      when(mockTrainingsplanerBusInterface.add())
          .thenAnswer((_) => Future.error("Future Error"));

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.addBusinessClass(
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
      expect(find.text("Future Error"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingsplanerBusInterface.add()).called(1);
      verify(mockTrainingsplanerBusInterface.reset()).called(1);
    });
  });
  group("updateBusinessClass", () {
    testWidgets("positive - should update a business class",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedBusinessClass(mockTrainingsplanerBusInterface,
          notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.updateBusinessClass(
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
      expect(find.text("Updated ${mockTrainingsplanerBusInterface.getName()}"),
          findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingsplanerBusInterface.update()).called(1);
    });

    testWidgets("positive - with notify false", (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedBusinessClass(mockTrainingsplanerBusInterface,
          notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.updateBusinessClass(
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
      expect(find.text("Updated ${mockTrainingsplanerBusInterface.getName()}"),
          findsOneWidget);
      expect(listenerCalled, false);
      verify(mockTrainingsplanerBusInterface.update()).called(1);
    });

    testWidgets("negative - should show error when method future.error",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedBusinessClass(mockTrainingsplanerBusInterface,
          notify: false);

      when(mockTrainingsplanerBusInterface.update())
          .thenAnswer((_) => Future.error("Future Error"));

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.updateBusinessClass(
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
      expect(find.text("Future Error"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingsplanerBusInterface.update()).called(1);
    });

    testWidgets(
        "negative - should show error when selected business class is not set",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.updateBusinessClass(
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
      expect(find.text("FormatException: No business class selected"),
          findsOneWidget);
      expect(listenerCalled, true);
    });
  });

  group("deleteBusinessClass", () {
    testWidgets("positive - should delete a business class",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedBusinessClass(mockTrainingsplanerBusInterface,
          notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.deleteBusinessClass(
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
      expect(find.text("deleted ${mockTrainingsplanerBusInterface.getName()}"),
          findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingsplanerBusInterface.delete()).called(1);
    });

    testWidgets(
        "positive - should delete a business class without notifying listeners",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedBusinessClass(mockTrainingsplanerBusInterface,
          notify: false);

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.deleteBusinessClass(
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
      expect(find.text("deleted ${mockTrainingsplanerBusInterface.getName()}"),
          findsOneWidget);
      expect(listenerCalled, false);
      verify(mockTrainingsplanerBusInterface.delete()).called(1);
    });

    testWidgets("negative - should show error when method future.error",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      provider.setSelectedBusinessClass(mockTrainingsplanerBusInterface,
          notify: false);

      when(mockTrainingsplanerBusInterface.delete())
          .thenAnswer((_) => Future.error("Future Error"));

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.deleteBusinessClass(
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
      expect(find.text("Future Error"), findsOneWidget);
      expect(listenerCalled, true);
      verify(mockTrainingsplanerBusInterface.delete()).called(1);
    });

    testWidgets(
        "negative - should show error when selected business class is not set",
        (WidgetTester tester) async {
      //arrange
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      //act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await provider.deleteBusinessClass(
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
      expect(find.text("FormatException: No business class selected"),
          findsOneWidget);
      expect(listenerCalled, true);
    });
  });
}
