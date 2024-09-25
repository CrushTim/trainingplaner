import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_report_interface.dart';
import 'package:trainingplaner/frontend/trainingsplaner_provider.dart';

import 'trainingsplaner_provider_test.mocks.dart';

class Tester implements TrainingsplanerBusInterface<Tester> {
  @override
  Future<void> add() {
    // TODO: implement add
    return Future.value();
  }

  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  String getId() {
    // TODO: implement getId
    throw UnimplementedError();
  }

  @override
  String getName() {
    return "Tester";
  }

  @override
  void mapFromOtherInstance(Tester other) {
    // TODO: implement mapFromOtherInstance
  }

  @override
  void reset() {
    // TODO: implement reset
  }

  @override
  toData() {
    // TODO: implement toData
    throw UnimplementedError();
  }

  @override
  Future<void> update() {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  void validateForAdd() {
    // TODO: implement validateForAdd
  }

  @override
  void validateForDelete() {
    // TODO: implement validateForDelete
  }

  @override
  void validateForUpdate() {
    // TODO: implement validateForUpdate
  }
}

//class MockTrainingsplanerBusInterface extends Mock implements TrainingsplanerBusInterface<MockTrainingsplanerBusInterface> {}
@GenerateNiceMocks([MockSpec<TrainingsplanerBusInterface>()])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TrainingsplanerProvider<TrainingsplanerBusInterface,
      TrainingsplanerBusReportInterface> provider;

  late Tester mockTrainingsplanerBusInterface;

  setUp(
    () {
      mockTrainingsplanerBusInterface = Tester();
      provider =
          TrainingsplanerProvider<Tester, TrainingsplanerBusReportInterface>(
        businessClassForAdd: mockTrainingsplanerBusInterface,
      );
    },
  );

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
}
