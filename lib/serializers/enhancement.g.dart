// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhancement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enhancement _$EnhancementFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'type', 'content', 'created_at', 'topic'],
  );
  return Enhancement(
    id: json['id'] as int,
    type: $enumDecode(_$EnhancementTypeEnumMap, json['type']),
    content: json['content'] as String,
    createAt: json['created_at'] as String,
    topic: Topic.fromJson(json['topic'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EnhancementToJson(Enhancement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$EnhancementTypeEnumMap[instance.type]!,
      'content': instance.content,
      'created_at': instance.createAt,
      'topic': instance.topic,
    };

const _$EnhancementTypeEnumMap = {
  EnhancementType.enhance: 'ENHANCE',
  EnhancementType.summarize: 'SUMMARIZE',
};
