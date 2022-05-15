import '../annotations.dart';
import 'validator.dart';

class RegexPatternValidator extends Validator<String, RegexPattern> {
  const RegexPatternValidator();

  @override
  List<String> validate(String value, RegexPattern rule) {
    final regexp = RegExp(rule.pattern, unicode: true);
    if (!regexp.hasMatch(value)) {
      return ["'$value' doesn't comply with regex '${rule.pattern}'"];
    }

    return const [];
  }
}
