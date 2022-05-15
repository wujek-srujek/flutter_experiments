import '../annotations.dart';
import 'int_range_validator.dart';
import 'regex_pattern_validator.dart';
import 'validator.dart';

class Validators {
  final _validators = <Type, Validator<Object, ValidationRule<Object>>>{};

  Validators._() {
    register(const IntRangeValidator());
    register(const RegexPatternValidator());
  }

  /// Registers a [Validator] for the [Validator.validationRuleType].
  ///
  /// It is an error to register a validator for a type that already has a
  /// validator.
  void register(Validator<Object, ValidationRule<Object>> validator) {
    final ruleType = validator.validationRuleType;
    if (_validators.containsKey(ruleType)) {
      throw StateError(
        "Validator for rule type '$ruleType' already registered",
      );
    }

    _validators[ruleType] = validator;
  }

  /// Validates [value] according to [rules].
  ///
  /// If the [value] is `null` or if no errors are detected the returned list
  /// will be empty, never `null`.
  ///
  /// This function is a helper which will be eventualy called by the generated
  /// validators and is not meant to be called directly by client code.
  List<String> validateValue(
    Object? value,
    List<ValidationRule<Object>> rules,
  ) {
    if (value == null) {
      return const [];
    }

    return rules
        .expand((rule) => _get(rule.runtimeType).validate(value, rule))
        .toList(growable: false);
  }

  Validator<Object, ValidationRule<Object>> _get(Type ruleType) {
    final validator = _validators[ruleType];
    if (validator == null) {
      throw StateError("No validator for rule type '$ruleType'");
    }

    return validator;
  }
}

final validators = Validators._();
