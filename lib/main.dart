import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/constants.dart';
import 'firebase_options.dart';
import 'main_application.dart';
import 'views/application_view.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.tracesSampleRate = 1.0;
      options.dsn = "https://4d8cc37455e948168ef47d19b80aa79c@o4504537892192256.ingest.sentry.io/4505607252738048";
    },
    appRunner: () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      MainApplication.sharedPreferences = await SharedPreferences.getInstance();

      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // available in mobile apps only
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // Lazy load ads
        AppLovinMAX.initialize("soO6pWhn7s2kMMeZhJ3qBqGfvepFKXcT2U2Wr3LSzA7FFrz8hEMSQ9Fm595iS17Cu4crlPUAGbBCFCvFODpXs5");
        // Lazy load notifications
        AwesomeNotifications().initialize(
          NotificationConstant.appIcon,
          debug: MainApplication.isDevelopment,
          NotificationConstant.notificationChannels,
          channelGroups: NotificationConstant.notificationChannelGroups,
        );
      }

      runApp(const ApplicationView());
    },
  );
}
