abstract class TrainingsplanerBusInterface<
    Subclass extends TrainingsplanerBusInterface<Subclass>> {
  // //////////////////////////////////////////////////////////////
  //                Getter                                      //
  // //////////////////////////////////////////////////////////////

  String getName();

  String getId();

  // //////////////////////////////////////////////////////////////
  //                Business-Operations                           //
  // //////////////////////////////////////////////////////////////

  void reset();

  void mapFromOtherInstance(Subclass other);

  toData();

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////

  Future<void> add();

  Future<void> update();

  Future<void> delete();

  // //////////////////////////////////////////////////////////////
  //                              Validation                     //
  // //////////////////////////////////////////////////////////////

  void validateForAdd();

  void validateForUpdate();

  void validateForDelete();
}
