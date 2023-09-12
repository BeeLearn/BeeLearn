import 'package:awesome_notifications/awesome_notifications.dart' show NotificationChannel, NotificationChannelGroup;

class _NotificationChannel {
  final String channelName;
  final String channelKey;
  final String channelGroupKey;
  final String channelGroupName;
  final String channelDescription;

  const _NotificationChannel({
    required this.channelName,
    required this.channelKey,
    required this.channelGroupKey,
    required this.channelDescription,
    String? optionalChannelGroupName,
  }) : channelGroupName = optionalChannelGroupName ?? channelName;
}

class NotificationConstant {
  static const appIcon = 'resource://drawable/splash';

  static const comment = _NotificationChannel(
    channelName: "Comment",
    channelKey: "comment_channel",
    channelGroupKey: "comment_channel_group",
    channelDescription: "Comment Notifications",
  );

  static const inApp = _NotificationChannel(
    channelName: "InApp",
    channelKey: "in_app_channel",
    channelGroupKey: "in_app_channel_group",
    channelDescription: "In app Notifications",
  );

  static const general = _NotificationChannel(
    channelName: "General",
    channelKey: "general_channel",
    channelGroupKey: "general_channel_group",
    channelDescription: "General notifications",
  );

  static const channels = [comment, inApp, general];

  static final notificationChannels = channels
      .map(
        (channel) => NotificationChannel(
          channelName: channel.channelName,
          channelKey: channel.channelKey,
          channelGroupKey: channel.channelGroupKey,
          channelDescription: channel.channelDescription,
        ),
      )
      .toList();

  static final notificationChannelGroups = channels
      .map(
        (channel) => NotificationChannelGroup(
          channelGroupKey: channel.channelGroupKey,
          channelGroupName: channel.channelGroupName,
        ),
      )
      .toList();
}
