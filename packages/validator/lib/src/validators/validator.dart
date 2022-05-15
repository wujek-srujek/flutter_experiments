import '../annotations.dart';

abstract class Validator<V, R extends ValidationRule<V>> {
  const Validator();

  /// The [ValidationRule] type this validator can process.
  Type get validationRuleType => R;

  /// Validates [value] according to the [rule].
  ///
  /// Returns a list of error strings if validation fails. If there are no
  /// errors the returned list will be empty, never `null`.
  List<String> validate(V value, R rule);
}
