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

  @JsonKey(required: true)
  final int streaks;

  @JsonKey(required: true, name: "daily_streak_minutes")
  int dailyStreakMinutes;

  int get dailyStreakSeconds => dailyStreakMinutes * 60;

  Profile({
    required this.id,
    required this.lives,
    required this.xp,
    required this.bits,
    required this.streaks,
    required this.dailyStreakMinutes,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
