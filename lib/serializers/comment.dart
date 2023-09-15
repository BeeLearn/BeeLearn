import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  @JsonKey(required: true)
  final User user;

  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String content;

  @JsonKey(required: true, name: "like_count")
  final int likeCount;

  @JsonKey(required: true, name: "is_liked")
  final bool isLiked;

  @JsonKey(required: true, name: "is_deleted")
  final bool isDeleted;

  @JsonKey(
    required: false,
    includeIfNull: true,
  )
  final Set<Comment>? replies;


  @JsonKey(required: true, name: "created_at")
  final DateTime createdAt;

  @JsonKey(required: true, name: "updated_at")
  final DateTime updatedAt;

  const Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.replies,
    required this.likeCount,
    required this.isLiked,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  bool operator ==(Object other) {
    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => Object.hashAll([id]);
}
