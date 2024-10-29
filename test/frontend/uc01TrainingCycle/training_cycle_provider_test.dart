import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/business/businessClasses/training_cycle_bus.dart';
import 'package:trainingplaner/business/reports/trainings_cycle_bus_report.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_list_tile.dart';
import 'package:trainingplaner/frontend/uc01TrainingCycle/training_cycle_provider.dart';
import 'package:flutter/material.dart';

import 'training_cycle_provider_test.mocks.dart';

//class MockTrainingCycleBusReport extends Mock implements TrainingCycleBusReport {}
//class MockTrainingCycleBus extends Mock implements TrainingCycleBus {}
@GenerateNiceMocks([MockSpec<TrainingCycleBus>(), MockSpec<TrainingCycleBusReport>()])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TrainingCycleProvider provider;
  late MockTrainingCycleBus mockTrainingCycleBus;
  late MockTrainingCycleBusReport mockTrainingCycleBusReport;

  setUp(() {
    mockTrainingCycleBus = MockTrainingCycleBus();
    mockTrainingCycleBusReport = MockTrainingCycleBusReport();
    provider = TrainingCycleProvider();
  });

  group('initState', () {
    test('should initialize controllers with selected business class data', () {
      // Arrange
      when(mockTrainingCycleBus.cycleName).thenReturn('Test Cycle');
      when(mockTrainingCycleBus.description).thenReturn('Test Description');
      when(mockTrainingCycleBus.emphasis).thenReturn(['Test Emphasis']);
      when(mockTrainingCycleBus.beginDate).thenReturn(DateTime(2024, 01, 01));
      when(mockTrainingCycleBus.endDate).thenReturn(DateTime(2024, 01, 31));

      provider.setSelectedBusinessClass(mockTrainingCycleBus);

      // Act
      provider.initState();

      // Assert
      expect(provider.nameController.text, 'Test Cycle');
      expect(provider.descriptionController.text, 'Test Description');
      expect(provider.emphasisController.text, 'Test Emphasis');
      expect(provider.startDateController.text, 'Date: 1.1.2024 ');
      expect(provider.endDateController.text, 'Date: 31.1.2024 ');
    });

    test('should initialize controllers with business class for add data when no selection', () {
      // Act
      provider.initState();

      // Assert
      expect(provider.nameController.text, '');
      expect(provider.descriptionController.text, '');
      expect(provider.emphasisController.text, '');
      expect(provider.startDateController.text, isNotEmpty);
      expect(provider.endDateController.text, isNotEmpty);
    });
  });

  group('updateStartDate', () {
    test('should update start date for selected business class', () {
      // Arrange
      final newDate = DateTime(2024, 2, 1);
      provider.setSelectedBusinessClass(mockTrainingCycleBus);

      // Act
      provider.updateStartDate(newDate);

      // Assert
      verify(mockTrainingCycleBus.beginDate = newDate);
      expect(provider.startDateController.text, 'Date: 1.2.2024 ');
    });

    test('should update start date for business class for add', () {
      // Arrange
      final newDate = DateTime(2024, 2, 1);

      // Act
      provider.updateStartDate(newDate);

      // Assert
      expect(provider.businessClassForAdd.beginDate, newDate);
      expect(provider.startDateController.text, 'Date: 1.2.2024 ');
    });
  });

  group('updateEndDate', () {
    test('should update end date for selected business class', () {
      // Arrange
      final newDate = DateTime(2024, 3, 1);
      provider.setSelectedBusinessClass(mockTrainingCycleBus);

      // Act
      provider.updateEndDate(newDate);

      // Assert
      verify(mockTrainingCycleBus.endDate = newDate);
      expect(provider.endDateController.text, 'Date: 1.3.2024 ');
    });

    test('should update end date for business class for add', () {
      // Arrange
      final newDate = DateTime(2024, 3, 1);

      // Act
      provider.updateEndDate(newDate);

      // Assert
      expect(provider.businessClassForAdd.endDate, newDate);
      expect(provider.endDateController.text, 'Date: 1.3.2024 ');
    });
  });

  group('updateParent', () {
    test('should update parent for selected business class', () {
      // Arrange
      const parentId = 'parent123';
      provider.setSelectedBusinessClass(mockTrainingCycleBus);

      // Act
      provider.updateParent(parentId);

      // Assert
      verify(mockTrainingCycleBus.parent = parentId);
      expect(provider.selectedParentId, parentId);
    });

    test('should update parent for business class for add', () {
      // Arrange
      const parentId = 'parent123';

      // Act
      provider.updateParent(parentId);

      // Assert
      expect(provider.businessClassForAdd.parent, parentId);
      expect(provider.selectedParentId, parentId);
    });
  });

  group('resetControllers', () {
    test('should clear all controllers', () {
      // Arrange
      provider.nameController.text = 'Test';
      provider.descriptionController.text = 'Description';
      provider.emphasisController.text = 'Emphasis';
      provider.startDateController.text = 'Date: 1.1.2024 ';
      provider.endDateController.text = 'Date: 31.1.2024 ';

      // Act
      provider.resetControllers();

      // Assert
      expect(provider.nameController.text, isEmpty);
      expect(provider.descriptionController.text, isEmpty);
      expect(provider.emphasisController.text, isEmpty);
      expect(provider.startDateController.text, isEmpty);
      expect(provider.endDateController.text, isEmpty);
    });
  });

  group('saveTrainingCycle', () {
    testWidgets('should save selected business class', (WidgetTester tester) async {
      // Arrange
      provider.setSelectedBusinessClass(mockTrainingCycleBus);
      when(mockTrainingCycleBus.update()).thenAnswer((_) => Future.value());
      when(mockTrainingCycleBus.getName()).thenReturn('Test Cycle');

      // Act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () => provider.saveTrainingCycle(ScaffoldMessenger.of(context)),
              child: const Text('Save'),
            );
            },
          ),
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      verify(mockTrainingCycleBus.update()).called(1);
      expect(provider.nameController.text, isEmpty);
      expect(provider.descriptionController.text, isEmpty);
      expect(provider.emphasisController.text, isEmpty);
    });
    //TODO:add negativ cases
    testWidgets('should save business class for add', (WidgetTester tester) async {
      // Arrange
      when(mockTrainingCycleBus.add()).thenAnswer((_) => Future.value('newId'));
      provider.businessClassForAdd = mockTrainingCycleBus;

      // Act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () => provider.saveTrainingCycle(ScaffoldMessenger.of(context)),
                child: const Text('Save'),
              );
            },
          ),
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      verify(mockTrainingCycleBus.add()).called(1);
      expect(provider.nameController.text, isEmpty);
      expect(provider.descriptionController.text, isEmpty);
      expect(provider.emphasisController.text, isEmpty);
    });
  });

  group('getTrainingCycles', () {
    testWidgets('should return a list of training cycles', (WidgetTester tester) async {
      // Arrange
      when(mockTrainingCycleBusReport.getAll()).thenAnswer((_) => Stream.value([mockTrainingCycleBus]));
      provider.reportTaskVar = mockTrainingCycleBusReport;

      // Act
      await tester.pumpWidget(MaterialApp(
        home: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => provider)
        ], child: Scaffold(body: ListView(children: [provider.getTrainingCycles()]))),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TrainingCycleListTile), findsOneWidget);
    });

    testWidgets('should return a empty list of training cycles', (WidgetTester tester) async {
      // Arrange
      when(mockTrainingCycleBusReport.getAll()).thenAnswer((_) => Stream.value([]));
      provider.reportTaskVar = mockTrainingCycleBusReport;

      // Act
      await tester.pumpWidget(MaterialApp(
        home: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => provider)
        ], child: Scaffold(body: ListView(children: [provider.getTrainingCycles()]))),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No training cycles available'), findsOneWidget);
    });

    testWidgets("should return a list with multiple training cycles", (WidgetTester tester) async {
      // Arrange
      when(mockTrainingCycleBusReport.getAll()).thenAnswer((_) => Stream.value([mockTrainingCycleBus, mockTrainingCycleBus]));
      provider.reportTaskVar = mockTrainingCycleBusReport;

      // Act
      await tester.pumpWidget(MaterialApp(
        home: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => provider)
        ], child: Scaffold(body: ListView(children: [provider.getTrainingCycles()]))),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TrainingCycleListTile), findsNWidgets(2));
    });

    testWidgets("should error and return a empty list", (WidgetTester tester) async {
      // Arrange
      when(mockTrainingCycleBusReport.getAll()).thenAnswer((_) => Stream.error('Test Error'));
      provider.reportTaskVar = mockTrainingCycleBusReport;

      // Act
      await tester.pumpWidget(MaterialApp(
        home: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => provider)
        ], child: Scaffold(body: ListView(children: [provider.getTrainingCycles()]))),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Error'), findsOneWidget);
    });
  });
}
