// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'module_id',
      'name',
      'is_unlocked',
      'is_completed'
    ],
  );
  return Lesson(
    id: json['id'] as int,
    moduleId: json['module_id'] as int,
    name: json['name'] as String,
    isUnlocked: json['is_unlocked'] as bool,
    isCompleted: json['is_completed'] as bool,
  );
}

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'module_id': instance.moduleId,
      'name': instance.name,
      'is_unlocked': instance.isUnlocked,
      'is_completed': instance.isCompleted,
    };
