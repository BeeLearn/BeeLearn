import 'package:beelearn/views/notification_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'views/enhancement_view.dart';
import 'views/main_view.dart';
import 'views/module_view.dart';
import 'views/onboarding_view.dart';
import 'views/search_view.dart';
import 'views/topic_view.dart';

/// Todo enhance
/// Todo Create a middleware wrapper
GoRouter router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AnnotatedRegion(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
        ),
        child: LoaderOverlay(
          overlayOpacity: 1,
          overlayColor: Colors.black45,
          child: child,
        ),
      ),
      routes: [
        GoRoute(
          path: "/onboarding",
          builder: (context, state) => const OnBoardingView(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const MainView(),
          routes: [
            GoRoute(
              path: "notifications",
              builder: (context, state) => const NotificationView(),
            ),
            GoRoute(
              path: "search",
              builder: (context, state) => const SearchView(),
            ),
            GoRoute(
              path: "topics",
              builder: (context, state) => TopicView(
                query: state.uri.queryParameters,
              ),
              routes: [
                GoRoute(
                  path: ":topicId/enhancements",
                  builder: (context, state) => EnhancementView(
                    topicId: state.uri.queryParameters["topicId"] as int,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "modules",
              builder: (context, state) {
                return ModuleView(
                  courseName: state.uri.queryParameters["courseName"],
                  query: state.pathParameters,
                );
              },
            ),
          ],
          redirect: (context, state) async {
            String? redirectPath;
            if (FirebaseAuth.instance.currentUser == null) redirectPath = "/onboarding";
            if (redirectPath == state.path) return null;

            return redirectPath;
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

final List<String> subscriptionBenefits = [
  "Unlimited heart refill",
  "Unlimited comments maxLength and personalize ai",
  "Frequent content update, premium users first",
  "Prioritized support and help to premium users",
  "Access to our VIP chat rooms on discord",
];
