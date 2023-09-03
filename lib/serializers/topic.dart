import 'package:beelearn/serializers/enhancement.dart';
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

  @JsonKey(required: false, name: "is_unlocked")
  final bool isUnlocked;

  @JsonKey(required: false, name: "is_completed")
  final bool isCompleted;

  @JsonKey(
    required: false,
    name: "has_assessment",
    defaultValue: false,
  )
  final bool hasAssessment;

  @JsonKey(includeToJson: false)
  Enhancement? enhancement;

  @JsonKey(required: false, name: "created_at")
  DateTime createdAt;

  @JsonKey(required: false, name: "updated_at")
  DateTime updatedAt;

  Topic({
    required this.id,
    required this.title,
    required this.content,
    required this.isLiked,
    required this.question,
    required this.isUnlocked,
    required this.isCompleted,
    required this.hasAssessment,
    required this.createdAt,
    required this.updatedAt,
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
    return TopicModel.updateTopic(
      id: id,
      data: {
        "topic_complete_users": {
          "add": [user.id],
        },
      },
    );
  }

  Future<Topic> setIsUnlocked(User user) {
    return TopicModel.updateTopic(
      id: id,
      data: {
        "entitled_users": {
          "add": [user.id],
        },
      },
    );
  }

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
