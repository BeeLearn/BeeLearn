// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reply _$ReplyFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'parent', 'comment'],
  );
  return Reply(
    id: json['id'] as int?,
    parent: json['parent'] as int,
    comment: Comment.fromJson(json['comment'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'comment': instance.comment,
    };
