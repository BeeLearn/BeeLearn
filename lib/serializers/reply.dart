import 'package:json_annotation/json_annotation.dart';

import 'comment.dart';

part 'reply.g.dart';

@JsonSerializable()
class Reply {
  @JsonKey(required: true, includeIfNull: true)
  final int? id;

  @JsonKey(required: true)
  final int parent;

  @JsonKey(required: true)
  final Comment comment;

  const Reply({
    this.id,
    required this.parent,
    required this.comment,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);
}
