import 'package:build/build.dart';

import 'common_extensions.dart';

class HelloPartBuilder implements Builder {
  final String _greeting;

  HelloPartBuilder(this._greeting);

  @override
  final buildExtensions = const {
    _dartExtension: [helloPartExtension],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final helloOutputId = inputId.changeExtension(helloPartExtension);
    final inputName = inputId
        .changeExtension('')
        .pathSegments
        // Drop the leading /lib.
        .sublist(1)
        .join('/');

    await buildStep.writeAsString(
      helloOutputId,
      _generate(_greeting, inputName),
    );
  }
}

String _generate(String greeting, String name) => '$greeting, $name!\n';

const _dartExtension = '.dart';
