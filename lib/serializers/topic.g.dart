// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'is_liked', 'title', 'content'],
  );
  return Topic(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    isLiked: json['is_liked'] as bool,
    question: json['question'] == null
        ? null
        : Question.fromJson(json['question'] as Map<String, dynamic>),
    isUnlocked: json['is_unlocked'] as bool,
    isCompleted: json['is_completed'] as bool,
    hasAssessment: json['has_assessment'] as bool? ?? false,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  )..enhancement = json['enhancement'] == null
      ? null
      : Enhancement.fromJson(json['enhancement'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'id': instance.id,
      'is_liked': instance.isLiked,
      'title': instance.title,
      'content': instance.content,
      'question': instance.question,
      'is_unlocked': instance.isUnlocked,
      'is_completed': instance.isCompleted,
      'has_assessment': instance.hasAssessment,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
