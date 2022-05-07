import 'package:build/build.dart';
import 'package:recase/recase.dart';

import 'common_extensions.dart';

class HelloDartBuilder implements Builder {
  @override
  final buildExtensions = const {
    helloPartExtension: [_helloDartExtension],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    final fieldName = _fieldNameFromAssetId(inputId);
    final fieldValue = (await buildStep.readAsString(inputId)).trim();

    // Change <file name>.hello.part to <file name>.hello.dart,
    // the '.hello' part stays unchanged.
    final outputId = inputId.changeExtension(dartExtension);

    return buildStep.writeAsString(
      outputId,
      _generate(fieldName, fieldValue),
    );
  }
}

// foo.hello.part -> helloFoo
// foo/bar/baz.hello.part -> helloFooBarBaz
String _fieldNameFromAssetId(AssetId assetId) {
  final segments = assetId.pathSegments;

  final fileNameWithExtension = segments.last;
  assert(fileNameWithExtension.endsWith(helloPartExtension));
  final fileName = fileNameWithExtension.substring(
    0,
    fileNameWithExtension.length - helloPartExtension.length,
  );
  final filePathSegments = [
    'hello',
    // Drop the /lib prefix and the file.
    ...segments.sublist(1, segments.length - 1),
    fileName,
  ];

  return filePathSegments.join('_').camelCase;
}

String _generate(String name, String value) => "const $name = '$value';\n";

const _helloDartExtension = '.hello.dart';
