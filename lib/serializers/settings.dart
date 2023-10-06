import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true, name: "is_promotional_email_enabled")
  bool isPromotionalEmailEnabled;

  @JsonKey(required: true, name: "is_push_notifications_enabled")
  bool isPushNotificationsEnabled;

  Settings({
    required this.id,
    required this.isPromotionalEmailEnabled,
    required this.isPushNotificationsEnabled,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
}
