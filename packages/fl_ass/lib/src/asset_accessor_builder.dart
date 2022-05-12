import 'package:build/build.dart';
import 'package:glob/glob.dart';

import 'asset_folder_codedegen_x.dart';
import 'asset_tree.dart';

class AssetAccessorBuilder implements Builder {
  final Iterable<Glob> assetDirs;
  final Iterable<Glob> exclusionFilters;

  AssetAccessorBuilder(List<String> assetDirs, List<String> exclusionFilters)
      : assetDirs = assetDirs.map((assetDir) => Glob('$assetDir/**')),
        exclusionFilters = exclusionFilters.map(Glob.new);

  @override
  final buildExtensions = const {
    _packageSynthethicInput: [_generatedAssetsAccessor],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final root = AssetFolder.root();
    for (final assetDir in assetDirs) {
      await buildStep
          .findAssets(assetDir)
          .map((assetId) => assetId.path)
          .where(_isAccepted)
          .forEach(root.addAsset);
    }

    return buildStep.writeAsString(
      buildStep.allowedOutputs.single,
      root.code(),
    );
  }

  bool _isAccepted(String path) {
    return !exclusionFilters.any((filter) => filter.matches(path));
  }
}

const _packageSynthethicInput = r'$package$';
const _generatedAssetsAccessor = 'lib/fl_ass.g.dart';
