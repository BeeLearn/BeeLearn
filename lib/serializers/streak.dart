import 'package:beelearn/main_application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'streak.g.dart';

@JsonSerializable()
class Streak {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final DateTime date;

  @JsonKey(required: true, name: "is_today")
  final bool isToday;

  @JsonKey(required: true, name: "is_complete")
  final bool isComplete;

  /// Load streak currentStreakSeconds from sharedPreference
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  int get currentStreakSeconds => MainApplication.sharedPreferences.getInt(date.toString()) ?? 0;

  /// Save streak state to sharedPreference
  set currentStreakSeconds(int seconds) {
    MainApplication.sharedPreferences.setInt(
      date.toString(),
      seconds,
    );
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get currentStreakMinutes => (currentStreakSeconds / 60).round();

  Streak({
    required this.id,
    required this.date,
    required this.isToday,
    required this.isComplete,
  });

  factory Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);
}
