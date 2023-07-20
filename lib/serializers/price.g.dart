// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Price _$PriceFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'xp', 'bits', 'type'],
  );
  return Price(
    id: json['id'] as int,
    xp: json['xp'] as int,
    bits: json['bits'] as int,
    type: $enumDecode(_$PriceTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'id': instance.id,
      'xp': instance.xp,
      'bits': instance.bits,
      'type': _$PriceTypeEnumMap[instance.type]!,
    };

const _$PriceTypeEnumMap = {
  PriceType.rewardAchieve: 'REWARD_ACHIEVE',
  PriceType.lessonComplete: 'LESSON_COMPLETE',
  PriceType.streakComplete: 'STREAK_COMPLETE',
};
