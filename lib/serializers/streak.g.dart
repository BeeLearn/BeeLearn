// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Streak _$StreakFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'date', 'is_today', 'is_complete'],
  );
  return Streak(
    id: json['id'] as int,
    date: json['date'] as String,
    isToday: json['is_today'] as bool,
    isComplete: json['is_complete'] as bool,
  );
}

Map<String, dynamic> _$StreakToJson(Streak instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'is_today': instance.isToday,
      'is_complete': instance.isComplete,
    };
