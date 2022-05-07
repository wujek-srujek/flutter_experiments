import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:recase/recase.dart';

import 'common_extensions.dart';

class HelloPartCollectorBuilder implements Builder {
  @override
  final buildExtensions = const {
    _packageSyntheticInput: [_helloGenDartOutput],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final code = await buildStep.findAssets(_helloPartGlob).asyncMap(
      (assetId) async {
        final fieldName = _fieldNameFromAssetId(assetId);
        final fieldValue = (await buildStep.readAsString(assetId)).trim();

        return _generate(fieldName, fieldValue);
      },
    ).join('\n');

    return buildStep.writeAsString(buildStep.allowedOutputs.single, '$code\n');
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

String _generate(String name, String value) => "const $name = '$value';";

const _packageSyntheticInput = r'$package$';
const _helloGenDartOutput = 'lib/hello.gen.dart';
final _helloPartGlob = Glob('**/*$helloPartExtension');
