// Mocks generated by Mockito 5.4.4 from annotations
// in trainingplaner/test/frontend/trainingsplaner_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i2;
import 'package:mockito/src/dummies.dart' as _i3;
import 'package:trainingplaner/business/trainingsplaner_bus_interface.dart'
    as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [TrainingsplanerBusInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockTrainingsplanerBusInterface<
        Subclass extends _i1.TrainingsplanerBusInterface<Subclass>>
    extends _i2.Mock implements _i1.TrainingsplanerBusInterface<Subclass> {
  @override
  String getName() => (super.noSuchMethod(
        Invocation.method(
          #getName,
          [],
        ),
        returnValue: _i3.dummyValue<String>(
          this,
          Invocation.method(
            #getName,
            [],
          ),
        ),
        returnValueForMissingStub: _i3.dummyValue<String>(
          this,
          Invocation.method(
            #getName,
            [],
          ),
        ),
      ) as String);

  @override
  String getId() => (super.noSuchMethod(
        Invocation.method(
          #getId,
          [],
        ),
        returnValue: _i3.dummyValue<String>(
          this,
          Invocation.method(
            #getId,
            [],
          ),
        ),
        returnValueForMissingStub: _i3.dummyValue<String>(
          this,
          Invocation.method(
            #getId,
            [],
          ),
        ),
      ) as String);

  @override
  void reset() => super.noSuchMethod(
        Invocation.method(
          #reset,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void mapFromOtherInstance(Subclass? other) => super.noSuchMethod(
        Invocation.method(
          #mapFromOtherInstance,
          [other],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<String> add() => (super.noSuchMethod(
        Invocation.method(
          #add,
          [],
        ),
        returnValue: _i4.Future<String>.value(_i3.dummyValue<String>(
          this,
          Invocation.method(
            #add,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<String>.value(_i3.dummyValue<String>(
          this,
          Invocation.method(
            #add,
            [],
          ),
        )),
      ) as _i4.Future<String>);

  @override
  _i4.Future<void> update() => (super.noSuchMethod(
        Invocation.method(
          #update,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> delete() => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void validateForAdd() => super.noSuchMethod(
        Invocation.method(
          #validateForAdd,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void validateForUpdate() => super.noSuchMethod(
        Invocation.method(
          #validateForUpdate,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void validateForDelete() => super.noSuchMethod(
        Invocation.method(
          #validateForDelete,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
