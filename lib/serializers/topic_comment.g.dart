// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicComment _$TopicCommentFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'is_parent',
      'user',
      'id',
      'content',
      'is_liked',
      'created_at',
      'updated_at'
    ],
  );
  return TopicComment(
    id: json['id'] as int,
    isParent: json['is_parent'] as bool,
    parentId: json['parent_id'] as int?,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    content: json['content'] as String,
    isLiked: json['is_liked'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    subTopicComments: (json['sub_topic_comments'] as List<dynamic>?)
        ?.map((e) => TopicComment.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TopicCommentToJson(TopicComment instance) {
  final val = <String, dynamic>{
    'is_parent': instance.isParent,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('parent_id', instance.parentId);
  val['user'] = instance.user;
  val['id'] = instance.id;
  val['content'] = instance.content;
  val['is_liked'] = instance.isLiked;
  val['created_at'] = instance.createdAt.toIso8601String();
  val['updated_at'] = instance.updatedAt.toIso8601String();
  writeNotNull('sub_topic_comments', instance.subTopicComments);
  return val;
}
