// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'is_promotional_email_enabled',
      'is_push_notifications_enabled'
    ],
  );
  return Settings(
    id: json['id'] as int,
    isPromotionalEmailEnabled: json['is_promotional_email_enabled'] as bool,
    isPushNotificationsEnabled: json['is_push_notifications_enabled'] as bool,
  );
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'id': instance.id,
      'is_promotional_email_enabled': instance.isPromotionalEmailEnabled,
      'is_push_notifications_enabled': instance.isPushNotificationsEnabled,
    };
