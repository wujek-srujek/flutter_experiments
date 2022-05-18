import 'package:meta/meta.dart';
import 'package:validator/validator.dart';

part 'user.g.dart';

@immutable
@validated
class User {
  @RegexPattern(pattern: r'^\p{Letter}+$')
  final String firstName;

  @RegexPattern(pattern: r'^(?:\p{Letter}+ )?\p{Letter}+$')
  final String lastName;

  @nonNegative
  @IntRange(max: 150)
  final int age;

  final String? comment;

  const User({
    required this.firstName,
    required this.lastName,
    required this.age,
    this.comment,
  });
}
