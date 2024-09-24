import 'package:flutter/material.dart';

abstract class TrainingsplanerBusInterface {
  String name = "";
  void reset();

  Future<void> addBusinessClass(ScaffoldMessengerState scaffoldMessengerState,
      {bool notify = true});

  Future<void> updateBusinessClass(
      ScaffoldMessengerState scaffoldMessengerState,
      {bool notify = true});

  Future<void> deleteBusinessClass(
      ScaffoldMessengerState scaffoldMessengerState,
      {bool notify = true});
}
