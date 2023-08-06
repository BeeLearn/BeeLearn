import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'models/user_model.dart';
import 'views/enhancement_view.dart';
import 'views/main_view.dart';
import 'views/module_view.dart';
import 'views/search_view.dart';
import 'views/topic_view.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainView(),
      routes: [
        GoRoute(
          path: "search",
          builder: (context, state) => const SearchView(),
        ),
        GoRoute(
          path: "topics",
          builder: (context, state) {
            return TopicView(query: state.queryParameters);
          },
          routes: [
            GoRoute(
              path: ":topicId/enhancements",
              builder: (context, state) => EnhancementView(
                topicId: state.pathParameters["topicId"] as int,
              ),
            ),
          ],
        ),
        GoRoute(
          path: "modules",
          builder: (context, state) {
            return ModuleView(
              courseName: state.queryParameters["courseName"],
              query: state.queryParameters,
            );
          },
        ),
      ],
      redirect: (context, state) async {
        /// Generate user from deviceId
        await UserModel.getCurrentUser().then((user) {
          Provider.of<UserModel>(context, listen: false).setUser(user);
        }).whenComplete(() => FlutterNativeSplash.remove());

        return null;
      },
    ),
  ],
);

const List<Breakpoint> defaultBreakpoints = [
  Breakpoint(start: 0, end: 640, name: MOBILE),
  Breakpoint(start: 640, end: 800, name: TABLET),
  Breakpoint(start: 801, end: 1920, name: DESKTOP),
];
