import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final int lives;

  @JsonKey(required: true)
  final int xp;

  @JsonKey(required: true)
  final int bits;

  const Profile({
    required this.id,
    required this.lives,
    required this.xp,
    required this.bits,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
