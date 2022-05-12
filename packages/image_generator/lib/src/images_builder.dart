import 'package:build/build.dart';

class ImagesBuilder implements Builder {
  @override
  final buildExtensions = const {
    _b64Extension: [_pngExtension],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    log.info('>>> ${buildStep.inputId}');
  }
}

const _b64Extension = '.b64';
const _pngExtension = '.png';
