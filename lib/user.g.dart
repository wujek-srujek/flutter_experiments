// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserCWProxy {
  User age(int age);

  User comment(String? comment);

  User firstName(String firstName);

  User lastName(String lastName);

  User pass(String pass);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `User(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// User(...).copyWith(id: 12, name: "My name")
  /// ````
  User call({
    int? age,
    String? comment,
    String? firstName,
    String? lastName,
    String? pass,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUser.copyWith.fieldName(...)`
class _$UserCWProxyImpl implements _$UserCWProxy {
  final User _value;

  const _$UserCWProxyImpl(this._value);

  @override
  User age(int age) => this(age: age);

  @override
  User comment(String? comment) => this(comment: comment);

  @override
  User firstName(String firstName) => this(firstName: firstName);

  @override
  User lastName(String lastName) => this(lastName: lastName);

  @override
  User pass(String pass) => this(pass: pass);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `User(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// User(...).copyWith(id: 12, name: "My name")
  /// ````
  User call({
    Object? age = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? firstName = const $CopyWithPlaceholder(),
    Object? lastName = const $CopyWithPlaceholder(),
    Object? pass = const $CopyWithPlaceholder(),
  }) {
    return User(
      age: age == const $CopyWithPlaceholder() || age == null
          ? _value.age
          // ignore: cast_nullable_to_non_nullable
          : age as int,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
      firstName: firstName == const $CopyWithPlaceholder() || firstName == null
          ? _value.firstName
          // ignore: cast_nullable_to_non_nullable
          : firstName as String,
      lastName: lastName == const $CopyWithPlaceholder() || lastName == null
          ? _value.lastName
          // ignore: cast_nullable_to_non_nullable
          : lastName as String,
      pass: pass == const $CopyWithPlaceholder() || pass == null
          ? _value.pass
          // ignore: cast_nullable_to_non_nullable
          : pass as String,
    );
  }
}

extension $UserCopyWith on User {
  /// Returns a callable class that can be used as follows: `instanceOfUser.copyWith(...)` or like so:`instanceOfUser.copyWith.fieldName(...)`.
  _$UserCWProxy get copyWith => _$UserCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      pass: json['pass'] as String,
      age: json['age'] as int,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'pass': instance.pass,
      'age': instance.age,
      'comment': instance.comment,
    };

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
      'pass': validatePass(),
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

  /// Validates this [User.pass].
  ///
  /// If there are no errors the returned list will be empty, never `null`.
  List<String> validatePass() {
    return validators.validateValue(
      pass,
      const [
        password,
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
