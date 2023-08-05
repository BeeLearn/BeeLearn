// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Module _$ModuleFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'name',
      'is_completed',
      'is_unlocked',
      'lessons'
    ],
  );
  return Module(
    id: json['id'] as int,
    name: json['name'] as String,
    isUnlocked: json['is_unlocked'] as bool,
    isCompleted: json['is_completed'] as bool,
    lessons: (json['lessons'] as List<dynamic>)
        .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ModuleToJson(Module instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_completed': instance.isCompleted,
      'is_unlocked': instance.isUnlocked,
      'lessons': instance.lessons,
    };
