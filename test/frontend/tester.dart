import 'package:flutter_test/flutter_test.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

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
