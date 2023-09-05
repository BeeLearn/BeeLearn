import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'topic_comment.g.dart';

@JsonSerializable()
class TopicComment {
  @JsonKey(required: true, name: "is_parent")
  final bool isParent;

  @JsonKey(
    required: false,
    includeIfNull: false,
    name: "parent_id",
  )
  final int? parentId;

  @JsonKey(required: true)
  final User user;

  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String content;

  @JsonKey(required: true, name: "is_liked")
  final bool isLiked;

  @JsonKey(required: true, name: "created_at")
  final DateTime createdAt;

  @JsonKey(required: true, name: "updated_at")
  final DateTime updatedAt;

  @JsonKey(
    required: false,
    includeIfNull: false,
    name: "sub_topic_comments",
  )
  final List<TopicComment>? subTopicComments;

  const TopicComment({
    required this.id,
    required this.isParent,
    required this.parentId,
    required this.user,
    required this.content,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
    required this.subTopicComments,
  });

  factory TopicComment.fromJson(Map<String, dynamic> json) => _$TopicCommentFromJson(json);

  Map<String, dynamic> toJson() => _$TopicCommentToJson(this);
}
