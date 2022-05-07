import 'package:build/build.dart';

class HelloBuilder implements Builder {
  final String _greeting;

  HelloBuilder(this._greeting);

  @override
  final buildExtensions = const {
    _dartExtension: [_helloExtension],
  };

  @override
  Future<void> build(BuildStep buildStep) {
    final inputId = buildStep.inputId;
    final helloOutputId = inputId.changeExtension(_helloExtension);
    final inputName = inputId
        .changeExtension('')
        .pathSegments
        // Drop the leading /lib.
        .sublist(1)
        .join('/');

    return buildStep.writeAsString(
      helloOutputId,
      _generate(_greeting, inputName),
    );
  }
}

String _generate(String greeting, String name) => '$greeting, $name!\n';

const _dartExtension = '.dart';
const _helloExtension = '.hello';
