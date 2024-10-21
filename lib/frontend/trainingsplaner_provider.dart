import 'package:flutter/material.dart';
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart';

class TrainingsplanerProvider<
    businessClass extends TrainingsplanerBusInterface<businessClass>,
    reportTask> extends ChangeNotifier {
  TrainingsplanerProvider(
      {required this.businessClassForAdd, required this.reportTaskVar});

  //report task to get the business Class from the database
  //accesable to be mocked in the test
  reportTask reportTaskVar;

  ///the selected business class
  ///it is null if no business class is selected
  businessClass? _selectedBusinessClass;

  ///the business class that is used for addition of new business classes
  ///the business class is initialized with default values
  ///the default values are defined in the business class
  businessClass businessClassForAdd;

  ///the list of business classes
  ///the list is initialized with an empty list
  ///the list is filled with the business classes from the database
  ///the update occurs when the view method with the streambuilder is called
  List<businessClass> businessClasses = [];

  // //////////////////////////////////////////////////////////////
  //                              Setter                         //
  // //////////////////////////////////////////////////////////////

  ///set the selected business class to a new business class given in the parameters
  ///if notify is true the listeners are notified
  ///usually called in the view when the user chooses a business class from a list to change / delete it
  ///@param businessClass the new business class
  ///@param notify if true the listeners are notified
  ///@return void
  void setSelectedBusinessClass(businessClass? businessClass,
      {bool notify = true}) {
    _selectedBusinessClass = businessClass;
    if (notify) {
      notifyListeners();
    }
  }

  ///set the business class for addition to a new business class given in the parameters
  ///if notify is true the listeners are notified
  ///usually called in the view when the user wants to add a new business class
  ///@param businessClass the new business class
  ///@param notify if true the listeners are notified
  ///@return void
  void setBusinessClassForAdd(businessClass businessClass,
      {bool notify = true}) {
    businessClassForAdd = businessClass;
    if (notify) {
      notifyListeners();
    }
  }

  // //////////////////////////////////////////////////////////////
  //                Resetters                                   //
  // //////////////////////////////////////////////////////////////

  ///reset the business class for addition
  ///calls the business class reset method
  ///the method is called when the user cancels the addition of a new business class
  ///or when the user has added a new business class
  ///the method is called in the view
  ///@return void
  void resetBusinessClassForAdd() {
    businessClassForAdd.reset();
  }

  ///reset the selected business class
  ///the method is called when the user cancels the selection of a business class
  ///or when the user has selected a business class
  ///the method is called in the view
  ///@return void
  void resetSelectedBusinessClass() {
    _selectedBusinessClass = null;
  }

  // //////////////////////////////////////////////////////////////
  //                Getters                                      //
  // //////////////////////////////////////////////////////////////

  ///get the selected business class
  ///returns null if no business class is selected
  ///the method is called when the view needs the selected business class
  ///usually when the user wants to change or delete a business class and the view needs to show the attributes of the selected business class
  ///returns null if no business class is selected
  ///@return businessClass the selected business class
  businessClass? get getSelectedBusinessClass {
    return _selectedBusinessClass;
  }

  ///get the business class for addition
  ///the method is called when the view needs the business class for addition
  ///usually when the user wants to add a new business class and the view needs to show the attributes of the business class for addition
  ///@return businessClass the business class for addition
  businessClass get getBusinessClassForAdd {
    return businessClassForAdd;
  }

  // //////////////////////////////////////////////////////////////
  //                CRUD-Operations                             //
  // //////////////////////////////////////////////////////////////

  ///add the business class for addition to the database
  /// uses a ScaffoldMessengerState to show a snackbar
  /// the method is called when the user wants to add a new business class
  /// the method is called in the view and acts on the business class for addition
  /// @param scaffoldMessengerState the scaffoldMessengerState to show the snackbar
  /// @param notify if true the listeners are notified
  /// @return Future<void> with the result of the addition
  Future<void> addForAddBusinessClass(
      ScaffoldMessengerState scaffoldMessengerState,
      {bool notify = true}) async {
    String message = "Added ${businessClassForAdd.getName()}";
    try {
      await businessClassForAdd
          .add()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      resetBusinessClassForAdd();
      if (notify) {
        notifyListeners();
      }

      scaffoldMessengerState.showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  ///update the selected business class in the database
  /// uses a ScaffoldMessengerState to show a snackbar
  /// the method is called when the user wants to update a business class
  /// the method is called in the view and acts on the selected business class
  /// if there is no selected business class the method shows the error
  /// @param scaffoldMessengerState the scaffoldMessengerState to show the snackbar
  /// @param notify if true the listeners are notified
  /// @return Future<void> with the result of the update
  Future<void> updateSelectedBusinessClass(
      ScaffoldMessengerState scaffoldMessengerState,
      {bool notify = true}) async {
    String message = "Updated ${_selectedBusinessClass?.getName()}";
    try {
      if (_selectedBusinessClass == null) {
        throw const FormatException("No business class selected");
      }
      await _selectedBusinessClass!
          .update()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  ///delete the selected business class from the database
  /// uses a ScaffoldMessengerState to show a snackbar
  /// the method is called when the user wants to delete a business class
  /// the method is called in the view and acts on the selected business class
  /// if there is no selected business class the method shows the error
  /// @param scaffoldMessengerState the scaffoldMessengerState to show the snackbar
  /// @param notify if true the listeners are notified
  /// @return Future<void> with the result of the deletion
  Future<void> deleteSelectedBusinessClass(
      ScaffoldMessengerState scaffoldMessengerState,
      {bool notify = true}) async {
    String message = "deleted ${_selectedBusinessClass?.getName()}";
    try {
      if (_selectedBusinessClass == null) {
        throw const FormatException("No business class selected");
      }
      await _selectedBusinessClass!
          .delete()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      resetSelectedBusinessClass();
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  ///add a business class to the database
  /// uses a ScaffoldMessengerState to show a snackbar
  /// @param businessClass the business class to add
  /// @param scaffoldMessengerState the scaffoldMessengerState to show the snackbar
  /// @param notify if true the listeners are notified
  /// @return Future<void> with the result of the addition
  Future<String> addBusinessClass(businessClass businessClassToAdd,
      ScaffoldMessengerState scaffoldMessengerState,
      {bool notify = true}) async {
    String message = "Added ${businessClassToAdd.getName()}";
    String addedId = "";
    try {
      
      addedId = await businessClassToAdd
          .add()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
    return addedId;
  }

  ///update a business class in the database
  /// uses a ScaffoldMessengerState to show a snackbar
  /// @param businessClass the business class to update
  /// @param scaffoldMessengerState the scaffoldMessengerState to show the snackbar
  /// @param notify if true the listeners are notified
  /// @return Future<void> with the result of the update
  Future<void> updateBusinessClass(businessClass businessClassToUpdate,
      ScaffoldMessengerState scaffoldMessengerState,
      {bool notify = true}) async {
    String message = "Updated ${businessClassToUpdate.getName()}";
    try {
      await businessClassToUpdate
          .update()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  ///delete a business class from the database
  /// uses a ScaffoldMessengerState to show a snackbar
  /// @param businessClass the business class to delete
  /// @param scaffoldMessengerState the scaffoldMessengerState to show the snackbar
  /// @param notify if true the listeners are notified
  /// @return Future<void> with the result of the deletion
  Future<void> deleteBusinessClass(businessClass businessClassToDelete,
      ScaffoldMessengerState scaffoldMessengerState,
      {bool notify = true}) async {
    String message = "deleted ${businessClassToDelete.getName()}";
    try {
      await businessClassToDelete
          .delete()
          .onError((error, stackTrace) => message = error.toString());
    } catch (e) {
      message = e.toString();
    } finally {
      if (notify) {
        notifyListeners();
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }
}
