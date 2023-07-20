import 'package:json_annotation/json_annotation.dart';

part 'price.g.dart';

@JsonEnum()
enum PriceType {
  @JsonValue("REWARD_ACHIEVE")
  rewardAchieve,
  @JsonValue("LESSON_COMPLETE")
  lessonComplete,
  @JsonValue("STREAK_COMPLETE")
  streakComplete,
}

@JsonSerializable()
class Price {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final int xp;

  @JsonKey(required: true)
  final int bits;

  @JsonKey(required: true)
  final PriceType type;

  const Price({
    required this.id,
    required this.xp,
    required this.bits,
    required this.type,
  });

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}
