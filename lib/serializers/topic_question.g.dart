// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicQuestion _$TopicQuestionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'topic', 'is_answered', 'question'],
  );
  return TopicQuestion(
    id: json['id'] as int,
    topic: json['topic'] as int,
    question: Question.fromJson(json['question'] as Map<String, dynamic>),
    isAnswered: json['is_answered'] as bool,
  );
}

Map<String, dynamic> _$TopicQuestionToJson(TopicQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'is_answered': instance.isAnswered,
      'question': instance.question,
    };
