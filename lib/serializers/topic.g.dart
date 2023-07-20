// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'is_liked', 'title', 'content', 'question'],
  );
  return Topic(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    isLiked: json['is_liked'] as bool,
    question: Question.fromJson(json['question'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'id': instance.id,
      'is_liked': instance.isLiked,
      'title': instance.title,
      'content': instance.content,
      'question': instance.question,
    };
