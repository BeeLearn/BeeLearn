// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'small_image',
      'content',
      'intent_to',
      'is_read',
      'createdAt',
      'updatedAt'
    ],
  );
  return Notification(
    id: json['id'] as int,
    smallImage: json['small_image'] as String?,
    content: json['content'] as String,
    intentTo: json['intent_to'] as String?,
    isRead: json['is_read'] as bool,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'small_image': instance.smallImage,
      'content': instance.content,
      'intent_to': instance.intentTo,
      'is_read': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
