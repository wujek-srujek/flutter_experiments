import 'dart:convert';

import 'package:build/build.dart';

class ImagesBuilder implements Builder {
  @override
  final buildExtensions = const {
    _b64Extension: [_pngExtension],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final b64 = await buildStep.readAsString(buildStep.inputId);
    final bytes = base64.decode(b64);

    final outputId = buildStep.inputId.changeExtension(_pngExtension);

    return buildStep.writeAsBytes(outputId, bytes);
  }
}

const _b64Extension = '.b64';
const _pngExtension = '.png';
