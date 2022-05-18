import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:validator/validator.dart';

part 'user.g.dart';

@immutable
@validated
@JsonSerializable()
@CopyWith()
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
