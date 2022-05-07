import 'package:build/build.dart';

class HelloBuilder implements Builder {
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
      _generate(inputName),
    );
  }
}

String _generate(String name) => 'Hello, $name!\n';

const _dartExtension = '.dart';
const _helloExtension = '.hello';
