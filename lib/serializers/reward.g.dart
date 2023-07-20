// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reward _$RewardFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'type',
      'title',
      'description',
      'icon',
      'color',
      'dark_color',
      'price',
      'is_unlocked'
    ],
  );
  return Reward(
    id: json['id'] as int,
    type: json['type'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    icon: json['icon'] as String,
    color: json['color'] as String,
    darkColor: json['dark_color'] as String,
    price: Price.fromJson(json['price'] as Map<String, dynamic>),
    isUnlocked: json['is_unlocked'] as bool,
  );
}

Map<String, dynamic> _$RewardToJson(Reward instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'color': instance.color,
      'dark_color': instance.darkColor,
      'price': instance.price,
      'is_unlocked': instance.isUnlocked,
    };
