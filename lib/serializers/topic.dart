import 'package:beelearn/models/topic_model.dart';
import 'package:beelearn/serializers/question.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true, name: "is_liked")
  bool isLiked;

  @JsonKey(required: true)
  final String title;

  @JsonKey(required: true)
  final String content;

  @JsonKey(required: false)
  final Question? question;

  Topic({
    required this.id,
    required this.title,
    required this.content,
    required this.isLiked,
    required this.question,
  });

  setIsLiked(bool state) {
    return TopicModel.updateTopic(id: id, data: {});
  }

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
