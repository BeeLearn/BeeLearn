// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Module _$ModuleFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'name', 'is_complete', 'is_locked'],
  );
  return Module(
    id: json['id'] as int,
    name: json['name'] as String,
    isLocked: json['is_locked'] as bool,
    isComplete: json['is_complete'] as bool,
  );
}

Map<String, dynamic> _$ModuleToJson(Module instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_complete': instance.isComplete,
      'is_locked': instance.isLocked,
    };
