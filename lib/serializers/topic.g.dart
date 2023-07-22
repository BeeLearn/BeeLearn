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
    isComplete: json['is_complete'] as bool,
    isUnlocked: json['is_unlocked'] as bool,
  );
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'id': instance.id,
      'is_liked': instance.isLiked,
      'title': instance.title,
      'content': instance.content,
      'question': instance.question,
      'is_complete': instance.isComplete,
      'is_unlocked': instance.isUnlocked,
    };
