import '../annotations.dart';
import 'validator.dart';

class IntRangeValidator extends Validator<int, IntRange> {
  const IntRangeValidator();

  @override
  List<String> validate(int value, IntRange rule) {
    final min = rule.min;
    if (min != null && value < min) {
      return ["'$value' is smaller than min '$min'"];
    }

    final max = rule.max;
    if (max != null && value > max) {
      return ["'$value' is greater than max '$max'"];
    }

    return const [];
  }
}
