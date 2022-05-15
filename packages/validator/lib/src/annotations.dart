import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

@immutable
@Target({TargetKind.classType})
class Validated {
  const Validated._();
}

const validated = Validated._();

abstract class ValidationRule<T> {}

@immutable
@Target({TargetKind.field})
class IntRange implements ValidationRule<int> {
  final int? min;
  final int? max;

  const IntRange({this.min, this.max});
}

const positive = IntRange(min: 1);
const negative = IntRange(max: 0);

const nonNegative = IntRange(min: 0);
const nonPositivie = IntRange(max: 0);

@immutable
@Target({TargetKind.field})
class RegexPattern implements ValidationRule<String> {
  final String pattern;

  const RegexPattern({required this.pattern});
}
