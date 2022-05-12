import 'package:build/build.dart';

import 'src/asset_accessor_builder.dart';

Builder flAss(BuilderOptions options) {
  return AssetAccessorBuilder(
    options.config.stringList('asset_dirs'),
    options.config.stringList('exclusion_filters'),
  );
}

extension _TypedConfig on Map<String, dynamic> {
  List<String> stringList(String key) {
    return (this[key]! as List<dynamic>).cast<String>();
  }
}
