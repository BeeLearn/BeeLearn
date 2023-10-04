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
      'icon',
      'topic',
      'image',
      'title',
      'body',
      'is_read',
      'metadata',
      'created_at',
      'updated_at'
    ],
  );
  return Notification(
    id: json['id'] as int,
    image: json['image'] as String,
    icon: json['icon'] as String?,
    topic: $enumDecode(_$NotificationTopicEnumMap, json['topic']),
    title: json['title'] as String,
    body: json['body'] as String,
    isRead: json['is_read'] as bool,
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'icon': instance.icon,
      'topic': _$NotificationTopicEnumMap[instance.topic]!,
      'image': instance.image,
      'title': instance.title,
      'body': instance.body,
      'is_read': instance.isRead,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$NotificationTopicEnumMap = {
  NotificationTopic.ads: 'ADS',
  NotificationTopic.live: 'LIVE',
  NotificationTopic.level: 'LEVEL',
  NotificationTopic.reward: 'REWARD',
  NotificationTopic.streak: 'STREAK',
  NotificationTopic.comment: 'COMMENT',
  NotificationTopic.general: 'GENERAL',
};
