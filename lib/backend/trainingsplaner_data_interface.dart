abstract class TrainingsplanerDataInterface {
  Map<String, dynamic> toJson();

  // /////////////////////////////////////////////
  // CRUD
  // /////////////////////////////////////////////
  Future<void> add();
  Future<void> update();
  Future<void> delete();
}
