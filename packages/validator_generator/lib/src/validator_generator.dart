import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:validator/validator.dart';

class ValidatorGenerator extends GeneratorForAnnotation<Validated> {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final body = await super.generate(library, buildStep);
    if (body == '') {
      return body;
    }

    final code = StringBuffer()
      ..write(
        """
// ignore_for_file: type=lint

import 'package:validator/validator.dart';

import '${library.element.source.shortName}';

""",
      )
      ..writeln(body);

    return code.toString();
  }

  @override
  String? generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final ruleCollectingVisitor = _RuleCollectingVisitor();
    element.visitChildren(ruleCollectingVisitor);

    if (ruleCollectingVisitor.fields.isEmpty) {
      log.warning(
        "'${element.name}' is annotated with '@$validated' "
        'but defines no rules, ignoring',
      );

      return null;
    }

    final typeName = element.name;

    final buffer = StringBuffer()
      ..write(
        '''
extension \$${typeName}ValidatorX on $typeName {
  /// Validates this [$typeName] and returns errors grouped by field name.
  ///
  /// If there are no errors for a given field there will be no mapping for it
  /// in the result. If there are no errors for any field the returned map will
  /// be empty, never `null`.
  Map<String, List<String>> validate() {
    return {
''',
      );

    for (final fieldName in ruleCollectingVisitor.fields.keys) {
      buffer.writeln(
        "      '$fieldName': validate${fieldName.capitalized()}(),",
      );
    }

    buffer.write(
      '''
    }..removeWhere((fieldName, errors) => errors.isEmpty);
  }

''',
    );

    for (final field in ruleCollectingVisitor.fields.entries) {
      buffer.write(
        '''
  /// Validates this [$typeName.${field.key}].
  ///
  /// If there are no errors the returned list will be empty, never `null`.
  List<String> validate${field.key.capitalized()}() {
    return validators.validateValue(
      ${field.key},
      const [
''',
      );

      for (final rule in field.value) {
        buffer.writeln('        $rule,');
      }

      buffer.write(
        '''
      ],
    );
  }

''',
      );
    }

    buffer.write(
      '''
  /// Whether this [$typeName] is valid.
  ///
  /// Call [validate] instead if detailed error information is needed.
  bool get isValid => validate().isEmpty;
}''',
    );

    return buffer.toString();
  }
}

class _RuleCollectingVisitor extends SimpleElementVisitor<void> {
  final Map<String, List<String>> fields = {};

  @override
  void visitFieldElement(FieldElement element) {
    final rules = element.metadata
        .where((annotation) {
          final annotationElement = annotation.element!;
          if (annotationElement is ConstructorElement) {
            // Handles '@Annotation(a: 1, b: 2)' (created with a constructor).
            return _validationRuleChecker.isAssignableFrom(
              annotationElement.enclosingElement,
            );
          } else if (annotationElement is PropertyAccessorElement) {
            // Handles '@annotation' (saved in a const).
            return _validationRuleChecker.isAssignableFrom(
              annotationElement.variable.type.element!,
            );
          }

          return false;
        })
        // Convert to source code snippt, drop the leading '@'.
        .map((annotation) => annotation.toSource().substring(1))
        .toList(growable: false);

    if (rules.isNotEmpty) {
      fields[element.name] = rules;
    }
  }
}

const _validationRuleChecker = TypeChecker.fromRuntime(ValidationRule<Object>);

extension _StringCapitalizedX on String {
  String capitalized() => '${this[0].toUpperCase()}${substring(1)}';
}
