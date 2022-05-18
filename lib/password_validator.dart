import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';
import 'package:validator/validator.dart';

@immutable
@Target({TargetKind.field})
class Password implements ValidationRule<String> {
  const Password._();
}

const password = Password._();

class PasswordValidator extends Validator<String, Password> {
  const PasswordValidator();

  @override
  List<String> validate(String value, Password rule) {
    final errors = <String>[];
    if (value.length < 8) {
      errors.add('Must have at least 8 characters.');
    }
    if (!value.contains(_digit)) {
      errors.add('Must contain at least 1 digit.');
    }
    if (!value.contains(_specialCharacter)) {
      errors.add("Must contain at least 1 of: '$_specialCharacterSet'.");
    }
    if (!value.contains(_lowercaseLetter)) {
      errors.add('Must contain at least 1 lowercase character.');
    }
    if (!value.contains(_uppercaseLetter)) {
      errors.add('Must contain at least 1 uppercase character.');
    }
    final charList = value.split('');
    for (var i = 0; i < charList.length - 1; ++i) {
      if (charList[i] == charList[i + 1]) {
        errors.add('Must not use the same character twice in a row.');
        break;
      }
    }

    return errors;
  }
}

final _digit = RegExp(r'[\d]');
const _specialCharacterSet = r'!@#$%^&*()_';
final _specialCharacter = RegExp('[$_specialCharacterSet]');
final _lowercaseLetter = RegExp(r'\p{Lowercase_Letter}', unicode: true);
final _uppercaseLetter = RegExp(r'\p{Uppercase_Letter}', unicode: true);
