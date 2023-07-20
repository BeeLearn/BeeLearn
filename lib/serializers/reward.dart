import 'package:beelearn/serializers/price.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward.g.dart';

@JsonSerializable()
class Reward {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String type;

  @JsonKey(required: true)
  final String title;

  @JsonKey(required: true)
  final String description;

  @JsonKey(required: true)
  final String icon;

  @JsonKey(required: true)
  final String color;

  @JsonKey(required: true, name: "dark_color")
  final String darkColor;

  @JsonKey(required: true)
  final Price price;

  @JsonKey(required: true, name: "is_unlocked")
  final bool isUnlocked;

  Color get lightModeColor => Color(int.parse(color));

  Color get darkModeColor => Color(int.parse(darkColor));

  const Reward({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.darkColor,
    required this.price,
    required this.isUnlocked,
  });

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);
}
