// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// ValidatorGenerator
// **************************************************************************

extension $UserValidatorX on User {
  /// Validates this [User] and returns errors grouped by field name.
  ///
  /// If there are no errors for a given field there will be no mapping for it
  /// in the result. If there are no errors for any field the returned map will
  /// be empty, never `null`.
  Map<String, List<String>> validate() {
    return {
      'firstName': validateFirstName(),
      'lastName': validateLastName(),
      'age': validateAge(),
    }..removeWhere((fieldName, errors) => errors.isEmpty);
  }

  /// Validates this [User.firstName].
  ///
  /// If there are no errors the returned list will be empty, never `null`.
  List<String> validateFirstName() {
    return validators.validateValue(
      firstName,
      const [
        RegexPattern(pattern: r'^\p{Letter}+$'),
      ],
    );
  }

  /// Validates this [User.lastName].
  ///
  /// If there are no errors the returned list will be empty, never `null`.
  List<String> validateLastName() {
    return validators.validateValue(
      lastName,
      const [
        RegexPattern(pattern: r'^(?:\p{Letter}+ )?\p{Letter}+$'),
      ],
    );
  }

  /// Validates this [User.age].
  ///
  /// If there are no errors the returned list will be empty, never `null`.
  List<String> validateAge() {
    return validators.validateValue(
      age,
      const [
        nonNegative,
        IntRange(max: 150),
      ],
    );
  }

  /// Whether this [User] is valid.
  ///
  /// Call [validate] instead if detailed error information is needed.
  bool get isValid => validate().isEmpty;
}
