import 'dart:developer';

import 'package:beelearn/main_application.dart';
import 'package:beelearn/views/application_view.dart';
import 'package:beelearn/widget_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest("User Stimulation E2E Testing", nativeAutomation: true, ($) async {
    await MainApplication.setUp(PatrolBinding.instance);

    /// user stimulation
    await $.pumpWidget(const ApplicationView());
    await $.pumpAndSettle();

    /// 1. Check if user is intent to OnboardingView or HomeView
    if ($(onBoardingViewKey).evaluate().isNotEmpty) {
      /// i. Sign up with Google SignIn, Then expect to Intent to home
      final googleSignInButton = find.byKey(onBoardingViewGoogleSignInButtonKey);
      final facebookSignInButton = find.byKey(onBoardingViewFacebookSignInButtonKey);

      expect(googleSignInButton, findsOneWidget);
      expect(facebookSignInButton, findsOneWidget);

      await $.tap(googleSignInButton);

      await $.pumpAndSettle();

      log("HEY I'm Called", error: googleSignInButton);

      await $.native.waitUntilVisible(
        Selector(text: "Choose an account"),
      );

      await $.native.tap(
        Selector(text: "Caleb Oguntunde"),
      );

      await $.pumpAndSettle();
    }

    /// ii. Home test runner
    //expect(find.byKey(mainViewKey), findsOneWidget);
    //expect(find.byKey(categoryTabViewKey), findsOneWidget);

    /// Todo
  });
}
