import 'package:json_annotation/json_annotation.dart';

import 'comment.dart';

part 'thread.g.dart';

@JsonSerializable()
class Thread {
  final String reference;

  final Comment comment;

  const Thread({
    required this.reference,
    required this.comment,
  });

  factory Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);
}
