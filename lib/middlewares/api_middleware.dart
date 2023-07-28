import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../djira_client/request.dart';
import '../main_application.dart';
import '../models/course_model.dart';
import '../models/reward_model.dart';
import '../models/streak_model.dart';
import '../serializers/course.dart';
import '../serializers/reward.dart';
import '../serializers/streak.dart';

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
    final socket = Request.createClient(
      MainApplication.baseURL,
      OptionBuilder().setAuth({
        "token": MainApplication.accessToken,
      }).setTransports(["websocket"]).build(),
    );

    socket.onConnect((data) {
      Request.subscribe(
        namespace: "courses",
        onError: (response) {},
        onSuccess: (response) {
          final course = Course.fromJson(response.data);
          final inProgressCourseModel = Provider.of<InProgressCourseModel>(context, listen: false);
          final completedCourseModel = Provider.of<CompletedCourseModel>(context, listen: false);

          if (course.isCompleted) {
            completedCourseModel.updateOrAddOne(course);
            inProgressCourseModel.removeOne(course);
          } else if (course.isEnrolled) {
            inProgressCourseModel.updateOrAddOne(course);
          }
        },
      );

      Request.subscribe(
        namespace: "favourites",
        onError: (response) {},
        onSuccess: (response) {
          final course = Course.fromJson(response.data);
          final favouriteCourseModel = Provider.of<FavouriteCourseModel>(context, listen: false);

          if (course.isLiked) {
            favouriteCourseModel.updateOrAddOne(course);
          } else {
            favouriteCourseModel.removeOne(course);
          }
        },
      );

      Request.subscribe(
        namespace: "rewards",
        onError: (response) {},
        onSuccess: (response) {
          final reward = Reward.fromJson(response.data);

          Provider.of<RewardModel>(context, listen: false).updateOrAddOne(reward);
          showSnackBar(
            leading: CircleAvatar(foregroundImage: NetworkImage(reward.icon)),
            title: reward.title,
            subtitle: reward.description,
          );
        },
      );

      Request.subscribe(
        namespace: "streaks",
        onError: (response) {},
        onSuccess: (response) {
          final streak = Streak.fromJson(response.data);
          Provider.of<StreakModel>(context, listen: false).updateOne(streak);

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
        },
      );
    });
  }
}
