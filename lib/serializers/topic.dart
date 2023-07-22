import 'package:beelearn/serializers/question.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/topic_model.dart';
import "../serializers/user.dart";

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

  Future<bool> setIsLiked(User user, bool state) {
    final action = state ? "add" : "remove";

    return TopicModel.updateTopic(id: id, data: {
      "likes": {
        action: [user.id]
      }
    }).then((_) => state);
  }

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
