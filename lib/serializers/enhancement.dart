import 'package:beelearn/serializers/topic.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enhancement.g.dart';

@JsonEnum()
enum EnhancementType {
  @JsonValue("ENHANCE")
  enhance,
  @JsonValue("SUMMARIZE")
  summarize,
}

@JsonSerializable()
class Enhancement {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final EnhancementType type;

  @JsonKey(required: true)
  final String content;

  @JsonKey(required: true, name: "created_at")
  final String createAt;

  @JsonKey(required: true)
  final Topic topic;

  const Enhancement({
    required this.id,
    required this.type,
    required this.content,
    required this.createAt,
    required this.topic,
  });

  factory Enhancement.fromJson(Map<String, dynamic> json) => _$EnhancementFromJson(json);
}
