import 'package:recase/recase.dart';

extension StringDartNameX on String {
  String toIdentifier() {
    var name = replaceAll(_disallowedCharacters, '_');
    if (name.startsWith(_digits)) {
      // Can't start with a digit, prefix with '$'.
      name = '\$$name';
    } else if (name.startsWith('_')) {
      // Would result in an unusable private identifier, prefix with '$'.
      name = '\$$name';
    }

    return name;
  }

  String toTypeName() => toIdentifier().pascalCase;
}

final _disallowedCharacters = RegExp(r'[^\w\d$_]');
final _digits = RegExp(r'\d');
