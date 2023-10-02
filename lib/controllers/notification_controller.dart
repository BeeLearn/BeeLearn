import 'dart:developer';
import 'dart:math' hide log;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';

import '../../mixins/api_model_mixin.dart';
import '../constants/notification_constant.dart';
import '../serializers/serializers.dart';
import 'controllers.dart';

class NotificationController with ApiModelMixin {
  @pragma("vm:entry-point")
  static Future<void> silentDataHandle(FcmSilentData silentData) async {
    log('"SilentData": ${silentData.toString()}');

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      log("bg", error: silentData.data);
    } else {
      log("FOREGROUND", error: silentData.data);
    }
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> fcmTokenHandle(String token) async {
    log('FCM Token:"$token"');
    await userController.updateCurrentUser(
      body: {
        "settings": {
          "fcm_token": token,
        }
      },
    );
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> nativeTokenHandle(String token) async {
    log('Native Token:"$token"');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.channelKey == NotificationConstant.comment.channelKey) {
      final payload = receivedAction.payload!;
      final message = "@${payload["reply.user.username"]} ${receivedAction.buttonKeyInput}";
      await replyController.createReply(
        body: {
          "user": payload["reply.user.id"],
          "parent": payload["thread.id"],
          "comment": {"content": message}
        },
      );

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          body: message,
          payload: payload,
          id: Random().nextInt(receivedAction.id!) + 256,
          channelKey: NotificationConstant.comment.channelKey,
          groupKey: NotificationConstant.comment.channelGroupKey,
          title: "You replied ${payload['reply.user.fullname']}",
        ),
      );
    }
  }

  @override
  String? get basePath => "api/account/notifications";

  Future<Paginate<Notification>> listNotifications<T>({
    String? url,
    Map<String, dynamic>? query,
  }) {
    return list(
      url: url,
      fromJson: (Map<String, dynamic> json) => Paginate.fromJson(
        json,
        Notification.fromJson,
      ),
    );
  }

  Future<Notification> updateNotification({
    required int id,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? body,
  }) {
    return super.update(
      path: id,
      query: query,
      body: body,
      fromJson: Notification.fromJson,
    );
  }

  Future<void> deleteNotification({required int id}) {
    return super.remove(path: id);
  }
}

final notificationController = NotificationController();
