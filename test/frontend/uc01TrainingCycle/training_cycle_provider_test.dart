import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
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
}
