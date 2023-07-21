import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/category_model.dart';
import 'models/course_model.dart';
import 'models/reward_model.dart';
import 'models/user_model.dart';
import 'views/main_view.dart';
import 'views/module_view.dart';
import 'views/topic_view.dart';

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
      redirect: (context, state) async {
        UserModel.getCurrentUser().then((user) {
          Provider.of<UserModel>(context, listen: false).setUser(user);
        }).whenComplete(() => FlutterNativeSplash.remove());

        return null;
      },
    ),
  ],
);

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryModel()),
        ChangeNotifierProvider(create: (context) => NewCourseModel()),
        ChangeNotifierProvider(create: (context) => InProgressCourseModel()),
        ChangeNotifierProvider(create: (context) => CompletedCourseModel()),
        ChangeNotifierProvider(create: (context) => RewardModel()),
        ChangeNotifierProvider(create: (context) => UserModel()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    ),
  );
}
