import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'main_application.dart';
import 'models/user_model.dart';
import 'views/main_view.dart';
import 'views/module_view.dart';
import 'views/topic_view.dart';

GoRouter router = GoRouter(
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
        /// Generate user from deviceId
        if (MainApplication.accessToken == null) {
          await UserModel.getOrCreateUser({"device_id": const Uuid().v4()}).then(
            (token) {
              MainApplication.accessToken = token.key;
            },
          );
        }

        await UserModel.getCurrentUser().then((user) {
          Provider.of<UserModel>(context, listen: false).setUser(user);
        }).whenComplete(() => FlutterNativeSplash.remove());

        return null;
      },
    ),
  ],
);
