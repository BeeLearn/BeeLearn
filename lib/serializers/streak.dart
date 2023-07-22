import 'package:json_annotation/json_annotation.dart';

part 'streak.g.dart';

@JsonSerializable()
class Streak {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String day;

  @JsonKey(required: true)
  final bool isComplete;

  const Streak({
    required this.id,
    required this.day,
    required this.isComplete,
  });

  factory Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);
}
