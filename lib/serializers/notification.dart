import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  @JsonKey(required: true)
  final int id;

  @JsonKey(
    required: true,
    includeIfNull: true,
    name: "small_image",
  )
  final String? smallImage;

  @JsonKey(required: true)
  final String content;

  @JsonKey(
    required: true,
    includeIfNull: true,
    name: "intent_to",
  )
  final String? intentTo;

  @JsonKey(required: true, includeIfNull: true, name: "is_read")
  final bool isRead;

  @JsonKey(required: true)
  final DateTime createdAt;

  @JsonKey(required: true)
  final DateTime updatedAt;

  const Notification({
    required this.id,
    required this.smallImage,
    required this.content,
    required this.intentTo,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
}
