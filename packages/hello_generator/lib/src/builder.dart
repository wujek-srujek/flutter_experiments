import 'package:build/build.dart';

import 'common_extensions.dart';
import 'hello_part_collector_builder.dart';

Builder helloCollectorBuilder(BuilderOptions options) {
  return HelloPartCollectorBuilder();
}

PostProcessBuilder partCleanup(BuilderOptions options) {
  return const FileDeletingBuilder([helloPartExtension]);
}
