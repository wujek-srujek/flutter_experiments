import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/validator_generator.dart';

Builder validatorBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [ValidatorGenerator()],
    'validator',
  );
}
