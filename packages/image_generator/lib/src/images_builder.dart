import 'dart:convert';

import 'package:build/build.dart';

class ImagesBuilder implements Builder {
  @override
  final buildExtensions = const {
    _b64InputExtension: [_assetsPngOutputExtension],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    final b64 = await buildStep.readAsString(inputId);
    final pngBytes = base64.decode(b64);

    final outputId = AssetId(
      inputId.package,
      '$_assetsFolder/${inputId.changeExtension('.png').path}',
    );

    return buildStep.writeAsBytes(outputId, pngBytes);
  }
}

const _pngExtension = '.png';
const _assetsFolder = 'assets';

const _b64InputExtension = '{{}}.b64';
const _assetsPngOutputExtension = '$_assetsFolder/{{}}$_pngExtension';
