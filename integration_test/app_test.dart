import 'package:beelearn/main_application.dart';
import 'package:beelearn/views/application_view.dart';
import 'package:beelearn/widget_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'extensions.dart';

Future<void> repeat(int count, Future<void> Function() callback) async {
  for (int touchTimes = 0; touchTimes <= count; touchTimes++) {
    await callback();
  }
}

void main() {
  final widgetsBinding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async => MainApplication.setUp(widgetsBinding));
  tearDownAll(() => MainApplication.dispose());

  group(
    "User E2E stimulation Test",
    () {
      testWidgets(
        "User Stimulation",
        (tester) async {
          final screenSize = tester.view.display.size;

          /// user stimulation
          await tester.pumpWidget(const ApplicationView());
          await tester.pumpAndSettle();

          /// 1. Check if user is intent to OnboardingView or HomeView
          if (find.byKey(onBoardingViewKey).evaluate().isNotEmpty) {
            /// i. Sign up with Google SignIn, Then expect to Intent to home
            final emailSignInButton = find.byKey(onBoardingViewEmailSignInButtonKey);
            final googleSignInButton = find.byKey(onBoardingViewGoogleSignInButtonKey);
            final facebookSignInButton = find.byKey(onBoardingViewFacebookSignInButtonKey);

            expect(emailSignInButton, findsOneWidget);
            expect(googleSignInButton, findsOneWidget);
            expect(facebookSignInButton, findsOneWidget);

            await tester.tap(emailSignInButton);

            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: "john@doe.com",
              password: "johndoe",
            );

            await tester.pumpAndSettle();
          }

          /// ii. Home test runner
          await repeat(3, () async {
            await tester.dragFrom(
              Offset(0, screenSize.height / 2),
              Offset(screenSize.width, screenSize.height / 2),
            );

            await tester.pumpAndSettle();
          });

          final streakActionButton = find.byKey(categoryStreakActionButtonKey);
          final lifeRefillActionButton = find.byKey(categoryLifeRefillActionButtonKey);
          final notificationActionButton = find.byKey(categoryNotificationActionButtonKey);

          expect(streakActionButton, findsOneWidget);
          expect(lifeRefillActionButton, findsOneWidget);
          expect(notificationActionButton, findsOneWidget);

          // Life refill modal test
          await tester.tap(lifeRefillActionButton);
          await tester.pumpAndSettleWithAfterDelay();

          final lifeRefillModalDismissButton = find.byKey(lifeRefillModalDismissButtonKey);
          expect(lifeRefillModalDismissButton, findsOneWidget);

          await tester.tap(lifeRefillModalDismissButton);
          await tester.pumpAndSettleWithAfterDelay();

          // streak modal test
          await tester.tap(streakActionButton);
          await tester.pumpAndSettleWithAfterDelay();

          final streakModalDismissButton = find.byKey(streakModalDismissButtonKey);
          expect(streakModalDismissButton, findsOneWidget);

          await tester.tap(streakModalDismissButton);
          await tester.pumpAndSettleWithAfterDelay();

          //notification modal test
          await tester.tap(notificationActionButton);
          await tester.pumpAndSettleWithAfterDelay();

          final notificationModalDismissButton = find.byKey(notificationModalDismissButtonKey);
          expect(notificationModalDismissButton, findsOneWidget);

          await tester.tap(notificationModalDismissButton);
          await tester.pumpAndSettleWithAfterDelay();

          // Goto Favorite Screen
          expect(find.byTooltip("Liked"), findsOneWidget);
          await tester.tap(find.byTooltip("Liked"));
          await tester.pumpAndSettleWithAfterDelay();

          // Goto Profile Screen
          expect(find.byTooltip("Profile"), findsOneWidget);

          await tester.tap(find.byTooltip("Profile"));
          await tester.pumpAndSettleWithAfterDelay();

          // show change goal modal
          final setStreakAction = find.byKey(profileStreakCardAdjustGoalActionKey);
          expect(setStreakAction, findsOneWidget);

          await tester.tap(setStreakAction);
          await tester.pumpAndSettleWithAfterDelay();

          final dismissSetStreakModalView = find.byKey(profileStreakCardDismissAdjustGoalModalKey);
          expect(dismissSetStreakModalView, findsOneWidget);

          await tester.tap(dismissSetStreakModalView);
          await tester.pumpAndSettleWithAfterDelay();

          // Show Settings Screen
          final settingsAction = find.byKey(settingsActionKey);
          expect(settingsAction, findsOneWidget);

          await tester.tap(settingsAction);
          await tester.pumpAndSettleWithAfterDelay();

          // Show Edit Profile Settings Screen
          final editProfileAction = find.byKey(editProfileActionKey);
          expect(editProfileAction, findsOneWidget);

          await tester.tap(editProfileAction);
          await tester.pumpAndSettleWithAfterDelay();

          // Show Change Avatar Modal
          final changeAvatarAction = find.byKey(editProfileChangeAvatarActionKey);
          expect(changeAvatarAction, findsOneWidget);

          await tester.tap(changeAvatarAction);
          await tester.pumpAndSettleWithAfterDelay();

          // Dismiss Change Avatar Dialog
          final changeAvatarModalBackButton = find.byKey(editProfileChangeAvatarBackButtonKey);
          expect(changeAvatarModalBackButton, findsOneWidget);

          await tester.tap(changeAvatarModalBackButton);
          await tester.pumpAndSettleWithAfterDelay();

          // Dismiss Edit Profile Settings
          final editProfileViewBackButton = find.byKey(editProfileViewBackButtonKey);
          expect(editProfileViewBackButton, findsOneWidget);

          await tester.tap(editProfileViewBackButton);
          await tester.pumpAndSettleWithAfterDelay();

          // show premium settings Screen
          final premiumSettingsAction = find.byKey(premiumSettingsActionKey);
          expect(premiumSettingsAction, findsOneWidget);

          await tester.tap(premiumSettingsAction);
          await tester.pumpAndSettleWithAfterDelay();

          final premiumSettingsViewBackButton = find.byKey(premiumSettingsViewBackButtonKey);
          expect(premiumSettingsViewBackButton, findsOneWidget);

          await tester.tap(premiumSettingsViewBackButton);
          await tester.pumpAndSettleWithAfterDelay();

          // show notifications settings screen
          final notificationsSettingsActionKey = find.byKey(notificationSettingsActionKey);
          expect(notificationsSettingsActionKey, findsOneWidget);

          await tester.tap(notificationsSettingsActionKey);
          await tester.pumpAndSettleWithAfterDelay();

          final notificationsSettingsViewBackButton = find.byKey(notificationSettingsViewBackButtonKey);
          expect(notificationsSettingsViewBackButton, findsOneWidget);

          await tester.tap(notificationsSettingsViewBackButton);
          await tester.pumpAndSettleWithAfterDelay();

          final settingsViewBackButton = find.byKey(settingsViewBackButtonKey);
          expect(settingsViewBackButton, findsOneWidget);

          await tester.tap(settingsViewBackButton);
          await tester.pumpAndSettleWithAfterDelay();

          // Go back to Category Screen
          expect(find.byTooltip("Category"), findsOneWidget);
          await tester.tap(find.byTooltip("Category"));
          await tester.pumpAndSettle();
        },
      );
    },
  );
}
