import 'package:beelearn/middlewares/api_middleware.dart';
import 'package:beelearn/views/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_application.dart';
import 'models/category_model.dart';
import 'models/course_model.dart';
import 'models/reward_model.dart';
import 'models/streak_model.dart';
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
            return TopicView(query: state.queryParameters);
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
        await UserModel.getCurrentUser().then((user) {
          Provider.of<UserModel>(context, listen: false).setUser(user);
        }).whenComplete(() => FlutterNativeSplash.remove());

        return null;
      },
    ),
  ],
);

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  MainApplication.sharedPreferences = await SharedPreferences.getInstance();
  await MainApplication.preferences.clear();

  runApp(const ApplicationView());
}

class ApplicationView extends StatefulWidget {
  const ApplicationView({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationViewState();
}

class _ApplicationViewState extends State<ApplicationView> {
  @override
  void initState() {
    super.initState();

    ApiMiddleware.run(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryModel()),
        ChangeNotifierProvider(create: (context) => NewCourseModel()),
        ChangeNotifierProvider(create: (context) => InProgressCourseModel()),
        ChangeNotifierProvider(create: (context) => CompletedCourseModel()),
        ChangeNotifierProvider(create: (context) => RewardModel()),
        ChangeNotifierProvider(create: (context) => StreakModel()),
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => FavouriteCourseModel()),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        scaffoldMessengerKey: MainApplication.scaffoldKey,
        home: Scaffold(
          body: MaterialApp.router(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}
