import 'package:build/build.dart';

import 'src/hello_part_builder.dart';

Builder helloBuilder(BuilderOptions options) {
  return HelloPartBuilder((options.config['greeting'] as String?) ?? 'Hello');
}
