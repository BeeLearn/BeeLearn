import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

enum NotificationTopic {
  @JsonValue("ADS")
  ads,
  @JsonValue("LIVE")
  live,
  @JsonValue("LEVEL")
  level,
  @JsonValue("REWARD")
  reward,
  @JsonValue("STREAK")
  streak,
  @JsonValue("COMMENT")
  comment,
  @JsonValue("GENERAL")
  general,
}

@JsonSerializable()
class Notification {
  @JsonKey(required: true)
  final int id;

  @JsonKey(
    required: true,
    includeIfNull: true,
  )
  final String? icon;

  @JsonKey(required: true)
  final NotificationTopic topic;

  @JsonKey(required: true)
  final String image;

  @JsonKey(required: true)
  final String title;

  @JsonKey(required: true)
  final String body;

  @JsonKey(
    required: true,
    includeIfNull: true,
    name: "is_read",
  )
  final bool isRead;

  @JsonKey(required: true, includeIfNull: true)
  final Map<String, dynamic>? metadata;

  @JsonKey(required: true, name: "created_at")
  final DateTime createdAt;

  @JsonKey(required: true, name: "updated_at")
  final DateTime updatedAt;

  const Notification({
    required this.id,
    required this.image,
    required this.icon,
    required this.topic,
    required this.title,
    required this.body,
    required this.isRead,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
}
