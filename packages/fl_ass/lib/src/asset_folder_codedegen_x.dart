import 'package:dart_style/dart_style.dart';

import 'asset_tree.dart';
import 'util.dart';

extension AssetFolderCodegenX on AssetFolder {
  /// Returns code for this folder.
  ///
  /// - Files in the folder are represented as simple getters, e.g.
  /// ```dart
  /// String get image_png => 'image.png';
  /// ```
  /// - Subfolders are represented as final properties, e.g.
  /// ```dart
  /// final Images images = Images._();
  /// ```
  /// and an accompanying type:
  /// ```dart
  /// class Images {
  ///     Images._();
  ///     // Nested file getters & folder properties.
  /// }
  /// ```
  /// This recurses for the full depth of the folder tree.
  String code() {
    final buffer = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln('// ignore_for_file: non_constant_identifier_names')
      ..writeln();

    // Top level properties are not wrapped in a type and have no indentation.
    final body = _bodyCode(indent: false);
    final types = _typesCode();

    buffer.write(body);
    if (body.isNotEmpty && types.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln();
    }
    buffer.write(types);

    if (body.isNotEmpty || types.isNotEmpty) {
      buffer.writeln();
    }

    return DartFormatter().format(buffer.toString());
  }

  /// Returns code for the body of the type represented by this folder.
  ///
  /// This includes the members but not the type name and constructor.
  String _bodyCode({required bool indent}) {
    final buffer = StringBuffer();

    void writeAll<T extends AssetElement>(
      Map<String, T> elements,
      String Function(T) memberCode,
    ) {
      buffer.writeAll(
        elements.values.map((T) => '${indent.indentation}${memberCode(T)}'),
        '\n',
      );
    }

    writeAll<AssetFile>(
      files,
      (file) => "String get ${file.identifier} => '${file.path}';",
    );
    if (files.isNotEmpty && folders.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln();
    }
    writeAll<AssetFolder>(
      folders,
      (folder) {
        final typeName = folder.path.toTypeName();

        return 'final $typeName ${folder.identifier} = $typeName._();';
      },
    );

    return buffer.toString();
  }

  /// Returns code for all types represented by subfolders, recursively.
  String _typesCode() {
    // Recursively flattens a folder tree.
    List<AssetFolder> expander(AssetFolder folder) {
      return [
        folder,
        ...folder.folders.values.expand(expander),
      ];
    }

    final buffer = StringBuffer()
      ..writeAll(
        folders.values
            .expand(expander)
            .map((folder) => folder._typeCode(indent: true)),
        '\n\n',
      );

    return buffer.toString();
  }

  /// Returns code for the type represented by this folder.
  String _typeCode({required bool indent}) {
    final typeName = path.toTypeName();
    final buffer = StringBuffer()
      ..writeln('class $typeName {')
      ..writeln('${true.indentation}$typeName._();');
    final body = _bodyCode(indent: true);
    if (body.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln(body);
    }
    buffer.write('}');

    return buffer.toString();
  }
}

extension _BoolIndentation on bool {
  String get indentation => this ? '  ' : '';
}
