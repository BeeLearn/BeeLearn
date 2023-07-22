// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Streak _$StreakFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'day', 'isComplete'],
  );
  return Streak(
    id: json['id'] as int,
    day: json['day'] as String,
    isComplete: json['isComplete'] as bool,
  );
}

Map<String, dynamic> _$StreakToJson(Streak instance) => <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'isComplete': instance.isComplete,
    };
