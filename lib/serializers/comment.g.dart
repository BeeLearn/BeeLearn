// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'user',
      'id',
      'content',
      'like_count',
      'is_liked',
      'is_deleted',
      'created_at',
      'updated_at'
    ],
  );
  return Comment(
    id: json['id'] as int,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    content: json['content'] as String,
    replies: (json['replies'] as List<dynamic>?)
        ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toSet(),
    likeCount: json['like_count'] as int,
    isLiked: json['is_liked'] as bool,
    isDeleted: json['is_deleted'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'user': instance.user,
      'id': instance.id,
      'content': instance.content,
      'like_count': instance.likeCount,
      'is_liked': instance.isLiked,
      'is_deleted': instance.isDeleted,
      'replies': instance.replies?.toList(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
