// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'is_liked',
      'title',
      'content',
      'topic_questions',
      'thread_reference'
    ],
  );
  return Topic(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    isLiked: json['is_liked'] as bool,
    topicQuestions: (json['topic_questions'] as List<dynamic>)
        .map((e) => TopicQuestion.fromJson(e as Map<String, dynamic>))
        .toList(),
    isUnlocked: json['is_unlocked'] as bool,
    isCompleted: json['is_completed'] as bool,
    threadReference: json['thread_reference'] as String,
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
      'topic_questions': instance.topicQuestions,
      'is_unlocked': instance.isUnlocked,
      'is_completed': instance.isCompleted,
      'thread_reference': instance.threadReference,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
