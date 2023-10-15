import 'package:beelearn/main_application.dart';
import 'package:beelearn/views/application_view.dart';
import 'package:beelearn/widget_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol/patrol.dart';

import 'extensions.dart';

Future<void> repeat(int count, Future<void> Function() callback) async {
  for (int touchTimes = 0; touchTimes <= count; touchTimes++) {
    await callback();
  }
}

void main() {
  // final widgetsBinding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  //
  // setUpAll(() async => MainApplication.setUp(widgetsBinding));
  // tearDownAll(() => MainApplication.dispose());

  patrolTest("User Stimulation", nativeAutomation: true, ($) async {
    await MainApplication.setUp(PatrolBinding.instance);

    final screenSize = $.tester.view.display.size;

    /// user stimulation
    await $.pumpWidget(const ApplicationView());

    /// 1. Check if user is intent to OnboardingView or HomeView
    if (find.byKey(onBoardingViewKey).evaluate().isNotEmpty) {
      /// i. Sign up with Google SignIn, Then expect to Intent to home
      final emailSignInButton = find.byKey(onBoardingViewEmailSignInButtonKey);
      final googleSignInButton = find.byKey(onBoardingViewGoogleSignInButtonKey);
      final facebookSignInButton = find.byKey(onBoardingViewFacebookSignInButtonKey);

      expect(emailSignInButton, findsOneWidget);
      expect(googleSignInButton, findsOneWidget);
      expect(facebookSignInButton, findsOneWidget);

      await $.tap(emailSignInButton);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "john@doe.com",
        password: "johndoe",
      );

      await $.pumpAndSettle();
    }

    /// ii. Home test runner
    await repeat(3, () async {
      await $.tester.flingFrom(
        Offset(0, screenSize.height * 0.8),
        Offset(screenSize.width, screenSize.height * 0.8),
        200,
      );

      await $.pumpAndSettle();
    });

    final streakActionButton = find.byKey(categoryStreakActionButtonKey);
    final lifeRefillActionButton = find.byKey(categoryLifeRefillActionButtonKey);
    final notificationActionButton = find.byKey(categoryNotificationActionButtonKey);

    expect(streakActionButton, findsOneWidget);
    expect(lifeRefillActionButton, findsOneWidget);
    expect(notificationActionButton, findsOneWidget);

    // streak modal test
    await $.tap(streakActionButton);
    await $.pumpAndSettle();

    await $.native.pressBack();
    await $.pumpAndSettle();

    // Life refill modal test
    await $.waitUntilVisible(lifeRefillActionButton);
    await $.tap(
      lifeRefillActionButton,
    );
    await $.pumpAndSettle();
    await $.native.pressBack();
    await $.pumpAndSettle();

    // notification modal test
    await $.waitUntilVisible(lifeRefillActionButton);
    await $.tap(notificationActionButton);
    await $.pumpAndSettle();
    await repeat(
      3,
          () async {
        await $.tester.startGesture(const Offset(0, 24));
        await $.pumpAndSettle();
      },
    );

    // Todo BottomNavigation
  });

}

