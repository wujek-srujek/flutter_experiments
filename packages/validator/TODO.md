## Ideas:

- Multi-field validators: validators that validate multiple fields together.
- Recursive validation: allow `@validated` on fields with complex types which
  in turn are `@validated` themselves with rules on their fields; support
  arbitrary depth. E.g.:
  ```dart
  @validated
  class User {
    // ...
    @validated
    final Wallet wallet;
    // ...
  }
  ```
- Rule composition: allow custom annotations that are annotated with rules
  to form a 'higher order' rule, e.g.:
  ```dart
  @immutable
  @Target({TargetKind.classType})
  @RuleA(foo = 1, bar = 'a')
  @RuleB()
  @RuleC(baz = false)
  class CompositeRule {
    const CompositeRule();
  }

  // ...

  @validated
  class Foo {
    @CompositeRule()
    final String bar;
    // ...
  ```
  Here annotating a field with `@CompositeRule` would apply all rules it is
  annotated with (`RuleA`, `RuleB` and `RuleC`); support arbitrary recursion,
  i.e. allow composite rules be annotated with other composite rules.
- Error keys - return an error object instead of a string. Such object has an
  errorr-specific key which allows clients, e.g. the UI, to get the key and show
  a UX-friendly message instead of a very technical error message, e.g.:
  `You must be of legal age.`
  instead of
  `'16' is smaller than min '18'`
- Continuing previous idea: define a callback that gets the technical error with
  a key and allows returning UX-friendly error messages. The callback can do
  localization etc. and would fall back to the technical error if unhandled. The
  callback gets registered with the validators infrastructure and gets called
  for every detected error.
