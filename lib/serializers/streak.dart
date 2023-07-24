import 'package:beelearn/main_application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'streak.g.dart';

@JsonSerializable()
class Streak {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String date;

  @JsonKey(required: true, name: "is_today")
  final bool isToday;

  @JsonKey(required: true, name: "is_complete")
  final bool isComplete;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get currentStreakSeconds => MainApplication.preferences.getInt(date) ?? 0;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get currentStreakMinutes => (currentStreakSeconds / 60).round();

  set currentStreakSeconds(int seconds) {
    MainApplication.preferences.setInt(date, seconds);
  }

  DateTime get dateTime => DateTime.parse(date);

  Streak({
    required this.id,
    required this.date,
    required this.isToday,
    required this.isComplete,
  });

  factory Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);
}
