import 'package:path/path.dart';

import 'util.dart';

abstract class AssetElement {
  final String identifier;
  final String path;

  AssetElement._(this.identifier, this.path);

  @override
  String toString() {
    return '$runtimeType($identifier, $path)';
  }
}

class AssetFile extends AssetElement {
  AssetFile._(String identifier, String path) : super._(identifier, path);
}

class AssetFolder extends AssetElement {
  final Map<String, AssetFile> files = {};
  final Map<String, AssetFolder> folders = {};

  AssetFolder._(String identifier, String path) : super._(identifier, path);

  AssetFolder.root() : this._('', '');

  void addAsset(String path) {
    final segments = posix.split(path);

    _doAddAsset(path, segments, 0, '');
  }

  void _doAddAsset(
    String assetPath,
    List<String> assetPathSegments,
    int depth,
    String parentFolderPath,
  ) {
    assert(posix.isWithin(path, assetPath));
    assert(assetPathSegments.length > depth);

    final subPath = posix.relative(assetPath, from: path);
    final name = assetPathSegments[depth];
    final identifier = name.toIdentifier();
    if (subPath.contains(posix.separator)) {
      final folderPath = posix.join(parentFolderPath, name);
      final folder = _ensureFolder(identifier, folderPath);
      folder._doAddAsset(assetPath, assetPathSegments, depth + 1, folder.path);
    } else {
      _addFile(identifier, assetPath);
    }
  }

  AssetFolder _ensureFolder(String identifier, String path) {
    var existingFolder = folders[identifier];
    if (existingFolder == null) {
      // Check if there is a conficting file.
      final existingFile = files[identifier];
      if (existingFile != null) {
        _fail("folder '$path'", "file '${existingFile.path}'", identifier);
      }

      existingFolder = AssetFolder._(identifier, path);
      folders[identifier] = existingFolder;
    } else if (existingFolder.path != path) {
      _fail("folder '$path'", "folder '${existingFolder.path}'", identifier);
    }

    return existingFolder;
  }

  void _addFile(String identifier, String path) {
    final existingFile = files[identifier];
    if (existingFile != null) {
      _fail("file '$path'", "file '${existingFile.path}'", identifier);
    }
    final existingFolder = folders[identifier];
    if (existingFolder != null) {
      _fail("file '$path'", "folder '${existingFolder.path}'", identifier);
    }

    files[identifier] = AssetFile._(identifier, path);
  }

  Never _fail(String newDesc, String existingDesc, String identifier) {
    throw StateError(
      """
Names for siblings $newDesc and $existingDesc normalize to the same
Dart identifier '$identifier'. Rename one of them.""",
    );
  }
}
