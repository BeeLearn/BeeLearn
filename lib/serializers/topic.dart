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
  final bool isLiked;

  @JsonKey(required: true)
  final String title;

  @JsonKey(required: true)
  final String content;

  @JsonKey(required: false)
  final Question? question;

  @JsonKey(required: false, name: "is_complete")
  final bool isComplete;

  @JsonKey(required: false, name: "is_unlocked")
  final bool isUnlocked;

  const Topic({
    required this.id,
    required this.title,
    required this.content,
    required this.isLiked,
    required this.question,
    required this.isComplete,
    required this.isUnlocked,
  });

  Future<Topic> setIsLiked(User user, bool state) {
    final action = state ? "add" : "remove";

    return TopicModel.updateTopic(id: id, data: {
      "likes": {
        action: [user.id]
      }
    });
  }

  Future<Topic> setIsComplete(User user) {
    return TopicModel.updateTopic(id: id, data: {
      "topic_complete_users": {
        "add": [user.id],
      },
    });
  }

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
