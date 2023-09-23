import 'package:json_annotation/json_annotation.dart';

import 'question.dart';

part 'topic_question.g.dart';

@JsonSerializable()
class TopicQuestion {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final int topic;

  @JsonKey(required: true, name: "is_answered")
  final bool isAnswered;

  @JsonKey(required: true)
  final Question question;

  const TopicQuestion({
    required this.id,
    required this.topic,
    required this.question,
    required this.isAnswered,
  });

  @override
  int get hashCode => Object.hashAll([id]);

  @override
  bool operator ==(Object other) => other is TopicQuestion && other.id == id && other.topic == topic && other.question.id == other.question.id;

  factory TopicQuestion.fromJson(Map<String, dynamic> json) => _$TopicQuestionFromJson(json);
}
