// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'name', 'is_unlocked', 'is_complete'],
  );
  return Lesson(
    id: json['id'] as int,
    name: json['name'] as String,
    isComplete: json['is_complete'] as bool,
    isUnlocked: json['is_unlocked'] as bool,
  );
}

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_unlocked': instance.isUnlocked,
      'is_complete': instance.isComplete,
    };
