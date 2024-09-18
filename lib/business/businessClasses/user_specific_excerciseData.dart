class UserSpecificExcerciseData {
  ///the id of the user specific excercise data link
  String excerciseLinkID;

  ///the id of the user
  String userID;

  ///the foundation id the user has specific data for
  String foundationId;

  ///Notes the user has written for this excercise
  String notes;

  ///the current one Rep Max
  double oneRepMax;

  UserSpecificExcerciseData({
    required this.excerciseLinkID,
    required this.userID,
    required this.foundationId,
    required this.notes,
    required this.oneRepMax,
  });

  ///factory method to create a training cycle from a data base object
  //TODO: implement the factory method

  ///method to convert the training cycle to a data base object
  //TODO: implement the toData method

  ///resets every field of the training cycle to the default value
  void reset() {
    excerciseLinkID = "";
    userID = "";
    foundationId = "";
    notes = "";
    oneRepMax = 0;
  }

  ///maps all attributes of another instance into this object
  void mapFromOtherInstance(UserSpecificExcerciseData other) {
    excerciseLinkID = other.excerciseLinkID;
    userID = other.userID;
    foundationId = other.foundationId;
    notes = other.notes;
    oneRepMax = other.oneRepMax;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                           //
  // //////////////////////////////////////////////////////////////

  Future<void> addUserSpecificExcerciseData() async {
    try {
      //TODO: implement the add method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

  Future<void> updateUserSpecificExcerciseData() async {
    try {
      //TODO: implement the update method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

  Future<void> deleteUserSpecificExcerciseData() async {
    try {
      //TODO: implement the delete method
    } on Exception catch (e) {
      return Future.error(Exception(e));
    }
  }

// //////////////////////////////////////////////////////////////
//                Validation Methods                         //
// //////////////////////////////////////////////////////////////

  void validateForAdd() {
    //check if foundationId is empty
    if (foundationId.isEmpty) {
      throw Exception("The foundationId is empty");
    }

    //check if userID is empty
    if (userID.isEmpty) {
      throw Exception("The userID is empty");
    }
  }

  void validateForUpdate() {
    //check if excerciseLinkID is empty
    if (excerciseLinkID.isEmpty) {
      throw Exception("The excerciseLinkID is empty");
    }

    //check if userID is empty
    if (userID.isEmpty) {
      throw Exception("The userID is empty");
    }

    //check if foundationId is empty
    if (foundationId.isEmpty) {
      throw Exception("The foundationId is empty");
    }
  }

  void validateForDelete() {
    //check if excerciseLinkID is empty
    if (excerciseLinkID.isEmpty) {
      throw Exception("The excerciseLinkID is empty");
    }
  }
}
