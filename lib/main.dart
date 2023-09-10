import 'package:applovin_max/applovin_max.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'main_application.dart';
import 'views/application_view.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  await dotenv.load(fileName: ".env");

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DNS'];
      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      MainApplication.sharedPreferences = await SharedPreferences.getInstance();

      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // await FirebaseMessaging.instance.setAutoInitEnabled(true);

      await AppLovinMAX.initialize(dotenv.env["APP_LOVIN_SDK_KEY"]!);

      /// Todo create a ui for this

      // await FirebaseMessaging.instance.requestPermission(
      //   alert: true,
      //   sound: true,
      //   badge: true,
      //   provisional: true,
      //   announcement: true,
      // );

      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/splash',
        [
          NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.redAccent,
            //ledColor: Colors.white,
          ),
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group',
          ),
        ],
        debug: true,
      );

      runApp(const ApplicationView());
    },
  );
}
