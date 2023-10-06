import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  int lives;

  @JsonKey(required: true)
  final int xp;

  @JsonKey(required: true)
  int bits;

  @JsonKey(required: true, name: "daily_streak_minutes")
  int dailyStreakMinutes;

  int get dailyStreakSeconds => dailyStreakMinutes * 60;

  /// This lives is gained via ads and not stored in database
  int temporaryLives = 0;

  /// User total lifeLine for this session
  int get lifeLine => lives + temporaryLives;

  Profile({
    required this.id,
    required this.lives,
    required this.xp,
    required this.bits,
    required this.dailyStreakMinutes,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
