import 'package:flutter_test/flutter_test.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

class Tester implements TrainingsplanerBusInterface<Tester> {
  String id;
  String name;
  Map<String, dynamic> data;

  Tester({this.id = '', this.name = 'Tester', this.data = const {}});

  @override
  Future<String> add() async {
    // Simulate adding to a database by generating a new ID
    id = DateTime.now().millisecondsSinceEpoch.toString();
    return id;
  } 
  
   @override
  Future<void> update() async {
    // Simulate update by doing nothing (assuming data is already updated)
  }



  @override
  Future<void> delete() async {
    // Simulate deletion by clearing data
    id = '';
    data.clear();
  }

  @override
  String getId() => id;

  @override
  String getName() => name;

  @override
  void mapFromOtherInstance(Tester other) {
    id = other.id;
    name = other.name;
    data = Map.from(other.data);
  }

  @override
  void reset() {
    id = '';
    name = 'Tester';
    data.clear();
  }

  @override
  Map<String, dynamic> toData() => {'id': id, 'name': name, ...data};


  @override
  void validateForAdd() {
    if (name.isEmpty) {
      throw Exception('Name cannot be empty for add operation');
    }
  }

  @override
  void validateForDelete() {
    if (id.isEmpty) {
      throw Exception('ID cannot be empty for delete operation');
    }
  }

  @override
  void validateForUpdate() {
    if (id.isEmpty || name.isEmpty) {
      throw Exception('ID and name cannot be empty for update operation');
    }
  }
}
