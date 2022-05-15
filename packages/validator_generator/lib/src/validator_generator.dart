import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:validator/validator.dart';

class ValidatorGenerator extends GeneratorForAnnotation<Validated> {
  @override
  String? generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    log.info('>>> $element');

    return null;
  }
}
