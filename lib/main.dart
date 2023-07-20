import 'package:beelearn/models/reward_model.dart';
import 'package:beelearn/views/main_view.dart';
import 'package:beelearn/views/module_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/category_model.dart';
import 'models/course_model.dart';
import 'views/lesson_view.dart';

GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainView(),
      routes: [
        GoRoute(
          path: "topics",
          builder: (context, state) {
            return TopicView(
              lessonId: int.parse(state.queryParameters["lessonId"]!),
            );
          },
        ),
        GoRoute(
          path: "modules",
          builder: (context, state) {
            return ModuleView(
              courseName: state.queryParameters["courseName"],
              courseId: int.parse(state.queryParameters["courseId"]!),
            );
          },
        ),
      ],
    ),
  ],
);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryModel()),
        ChangeNotifierProvider(create: (context) => NewCourseModel()),
        ChangeNotifierProvider(create: (context) => InProgressCourseModel()),
        ChangeNotifierProvider(create: (context) => CompletedCourseModel()),
        ChangeNotifierProvider(create: (context) => RewardModel()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    ),
  );
}
