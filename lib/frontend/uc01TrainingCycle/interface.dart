import 'package:flutter/material.dart';

class PerspectiveProvider<businessClass, reportTask> extends ChangeNotifier {
  PerspectiveProvider({required this.businessClassForAdd});

  //report task to get the business Class from the database
  //accesable to be mocked in the test
  reportTask? reportTaskVar;

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
  ///the method is called when a business class is selected in the view
  ///usually when the user chooses a business class from a list to change / delete it
  ///the method is called in the view
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
  ///the method is called when a new business class should be added (on an addition view)
  ///usually when the user wants to add a new business class
  ///the method is called in the view
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
    //businessClassForAdd.reset();
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
}
