import 'dart:developer';

import 'package:djira_client/djira_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../main_application.dart';
import '../models/course_model.dart';
import '../models/reward_model.dart';
import '../models/streak_model.dart';
import '../models/user_model.dart';
import '../serializers/course.dart';
import '../serializers/profile.dart';
import '../serializers/reward.dart';
import '../serializers/streak.dart';
import '../socket_client.dart';

void showSnackBar({
  String? subtitle,
  SnackBarAction? action,
  required Widget leading,
  required String title,
}) {
  MainApplication.scaffoldKey.currentState?.showSnackBar(
    SnackBar(
      padding: EdgeInsets.zero,
      content: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
              ),
      ),
      action: action,
      backgroundColor: Colors.black,
    ),
  );
}

class ApiMiddleware {
  static void run(BuildContext context) {
    createClient(MainApplication.accessToken);

    client?.socket.onConnect((data) async {
      final unsubscribeCourseListener = await client?.subscribe(
        namespace: "courses",
        onError: (response) {},
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

      final unsubscribeFavouriteListener = await client?.subscribe(
        namespace: "favourites",
        onError: (response) {},
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

      final unsubscribeRewardListener = await client?.subscribe(
        namespace: "rewards",
        onError: (response) {},
        onSuccess: (response) {
          log("OnSuccess", error: response.data);
          try {
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
          } catch (error, stackTrace) {
            log("Subscription error", error: error, stackTrace: stackTrace);
          }
        },
      );

      final unsubscribeStreakListener = await client?.subscribe(
        namespace: "streaks",
        onError: (response) {},
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

      final unsubscribeProfileListener = await client?.subscribe(
        namespace: "profiles",
        onError: (response) {},
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

      // client?.socket.onDisconnect((data) {
      //   unsubscribeProfileListener!();
      //   unsubscribeCourseListener!();
      //   unsubscribeFavouriteListener!();
      //   unsubscribeRewardListener!();
      //   unsubscribeStreakListener!();
      // });
    });
  }
}
