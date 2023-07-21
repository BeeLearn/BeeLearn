import 'package:beelearn/serializers/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String username;

  @JsonKey(required: true)
  final String email;

  @JsonKey(required: true)
  final Profile profile;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
