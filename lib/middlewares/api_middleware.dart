import 'dart:developer';

import 'package:djira_client/djira_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../main_application.dart';
import '../models/models.dart';
import '../serializers/serializers.dart';
import '../serializers/serializers.dart' as serializer;
import '../socket_client.dart';

void showSnackBar({
  String? subtitle,
  Widget? leading,
  SnackBarAction? action,
  ScaffoldMessengerState? scaffoldMessenger,
  SnackBarBehavior barBehavior = SnackBarBehavior.fixed,
  required String title,
}) {
  (scaffoldMessenger ?? MainApplication.scaffoldKey.currentState!).showSnackBar(
    SnackBar(
      padding: EdgeInsets.zero,
      content: ListTile(
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70),
              ),
      ),
      action: action,
      backgroundColor: Colors.black,
    ),
  );
}

class _NotificationResponse {
  final int unread;
  final serializer.Notification notification;

  const _NotificationResponse({
    required this.unread,
    required this.notification,
  });

  factory _NotificationResponse.fromJson(Map<String, dynamic> json) => _NotificationResponse(
        unread: json["unread"] as int,
        notification: serializer.Notification.fromJson(json["notification"] as Map<String, dynamic>),
      );
}

class ApiMiddleware {
  static void _onError(Response response) {
    log(
      "Socket API error",
      error: {
        "requestId": response.requestId,
        "data": response.data,
      },
    );
  }

  static void run(BuildContext context) {
    createClient(MainApplication.accessToken);

    client?.socket.onConnect((data) async {
      client?.subscribe(
        namespace: "courses",
        onError: _onError,
        onSuccess: (response) {
          final course = Course.fromJson(response.data);
          final inProgressCourseModel = Provider.of<InProgressCourseModel>(
            context,
            listen: false,
          );
          final completedCourseModel = Provider.of<CompletedCourseModel>(
            context,
            listen: false,
          );

          if (course.isCompleted) {
            completedCourseModel.updateOrAddOne(course);
            inProgressCourseModel.removeOne(course);
          } else if (course.isEnrolled) {
            inProgressCourseModel.updateOrAddOne(course);
          }
        },
      );

      client?.subscribe(
        namespace: "favourites",
        onError: _onError,
        onSuccess: (response) {
          final course = Course.fromJson(response.data);
          final favouriteCourseModel = Provider.of<FavouriteCourseModel>(
            context,
            listen: false,
          );

          if (course.isLiked) {
            favouriteCourseModel.updateOrAddOne(course);
          } else {
            favouriteCourseModel.removeOne(course);
          }
        },
      );

      client?.subscribe(
        namespace: "rewards",
        onError: _onError,
        onSuccess: (response) {
          final reward = Reward.fromJson(response.data);

          Provider.of<RewardModel>(
            context,
            listen: false,
          ).updateOrAddOne(reward);
          showSnackBar(
            leading: CircleAvatar(foregroundImage: NetworkImage(reward.icon)),
            title: reward.title,
            subtitle: reward.description,
          );
        },
      );

      client?.subscribe(
        namespace: "streaks",
        onError: _onError,
        onSuccess: (response) {
          final streak = Streak.fromJson(response.data);
          Provider.of<StreakModel>(
            context,
            listen: false,
          ).updateOne(streak);

          if (response.type == Type.updated) {
            showSnackBar(
              leading: const Icon(
                CupertinoIcons.flame_fill,
                color: Colors.green,
              ),
              title: "You achieved a new streak! Way to go!",
              action: SnackBarAction(
                label: "Share",
                onPressed: () {},
              ),
            );
          }
        },
      );

      client?.subscribe(
        namespace: "profiles",
        onError: _onError,
        onSuccess: (response) {
          final userModel = Provider.of<UserModel>(
            context,
            listen: false,
          );
          final user = userModel.value;
          user.profile = Profile.fromJson(response.data);

          userModel.value = user;
        },
      );

      client?.subscribe(
        namespace: "notifications",
        onError: _onError,
        onSuccess: (response) {
          NotificationModel notificationModel = Provider.of<NotificationModel>(
            context,
            listen: false,
          );

          UserModel userModel = Provider.of<UserModel>(
            context,
            listen: false,
          );

          _NotificationResponse data = _NotificationResponse.fromJson(response.data);

          User user = userModel.value;
          user.unreadNotifications = data.unread;
          userModel.value = user;

          switch (response.type!) {
            case Type.created:
              notificationModel.setOne(data.notification);
              break;
            case Type.updated:
              notificationModel.updateOrAddOne(data.notification);
              break;
            case Type.removed:
              notificationModel.removeOne(data.notification);
              break;
          }
        },
      );

      client?.subscribe(
        namespace: "purchases",
        onError: _onError,
        onSuccess: (response) {
          final purchaseModel = Provider.of<PurchaseModel>(
            context,
            listen: false,
          );

          final userModel = Provider.of<UserModel>(
            context,
            listen: false,
          );

          final purchase = Purchase.fromJson(response.data);

          switch (response.type!) {
            case Type.created:
            case Type.updated:
              purchaseModel.updateOrAddOne(purchase);
              // If purchase is a type of subscription and status is successful then user is a premium user
              if (!purchase.product.consumable) {
                final user = userModel.value;
                user.isPremium = purchase.status == PurchaseStatus.successful;
                userModel.value = user;
              }

              break;
            case Type.removed:
              purchaseModel.removeOne(purchase);
              break;
          }
        },
      );
    });
  }
}
