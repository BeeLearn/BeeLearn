import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/constants.dart';
import 'firebase_options.dart';
import 'main_application.dart';
import 'views/application_view.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  await SentryFlutter.init(
    (options) {
      options.tracesSampleRate = 1.0;
      options.dsn = EnvConstant.sentryDns;
    },
    appRunner: () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      MainApplication.sharedPreferences = await SharedPreferences.getInstance();

      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // available in mobile apps only
      if (!kIsWeb && Platform.isAndroid && Platform.isIOS) {
        // Lazy load ads
        AppLovinMAX.initialize(EnvConstant.appLovinSdkKey);
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
