import 'package:build/build.dart';

class HelloBuilder implements Builder {
  @override
  final buildExtensions = const {
    _dartExtension: [_helloExtension],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    log.info('>>> Hello, builder!');
  }
}

const _dartExtension = '.dart';
const _helloExtension = '.hello';
