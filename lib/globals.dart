import 'package:beelearn/views/passwordless_signin_view.dart';
import 'package:beelearn/views/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'main_application.dart';
import 'views/enhancement_view.dart';
import 'views/main_view.dart';
import 'views/module_view.dart';
import 'views/search_view.dart';
import 'views/topic_view.dart';

GoRouter router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => LoaderOverlay(
        overlayColor: Colors.black45,
        closeOnBackButton: true,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        ),
      ),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MainView(),
          routes: [
            GoRoute(
              path: "sign-in",
              builder: (context, state) => const SignInView(),
            ),
            GoRoute(
              path: "passwordless-sign-in",
              builder: (context, state) => const PasswordLessSignInView(),
            ),
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
            if (MainApplication.accessToken == null) {
              FlutterNativeSplash.remove();

              if (state.location!.contains("sign-in")) return null;

              return "/passwordless-sign-in";
            }

            return null;
          },
        ),
      ],
    )
  ],
);

const List<Breakpoint> defaultBreakpoints = [
  Breakpoint(start: 0, end: 640, name: MOBILE),
  Breakpoint(start: 640, end: 800, name: TABLET),
  Breakpoint(start: 801, end: 1920, name: DESKTOP),
];
