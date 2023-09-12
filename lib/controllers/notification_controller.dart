import 'dart:developer';
import 'dart:math' show Random;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:beelearn/constants/constants.dart';

import '../controllers/topic_comment_controller.dart';
import '../controllers/user_controller.dart';

class NotificationController {
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
      final message = "@${payload["sender_username"]} ${receivedAction.buttonKeyInput}";

      await topicCommentController.updateTopicComment(
        id: int.parse(payload["thread_id"]!),
        body: {
          "content": message,
          "topic": int.parse(payload["topic_id"]!),
        },
      );

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          body: message,
          payload: payload,
          id: Random().nextInt(receivedAction.id!) + 256,
          channelKey: NotificationConstant.comment.channelKey,
          groupKey: NotificationConstant.comment.channelGroupKey,
          title: "You replied ${payload['sender_full_name']}",
        ),
      );
    }
  }
}
