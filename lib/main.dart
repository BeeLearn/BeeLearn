import 'package:beelearn/views/module_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/category_model.dart';
import 'models/course_model.dart';
import 'views/home_view.dart';
import 'views/lesson_view.dart';

GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
      routes: [
        GoRoute(
          path: "lessons",
          builder: (context, state) {
            return LessonView(
              courseId: int.parse(state.queryParameters["moduleId"]!),
            );
          },
        ),
        GoRoute(
          path: "modules",
          builder: (context, state) {
            return ModuleView(
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
      ],
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    ),
  );
}
