import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:beelearn/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

/// global app state instance
class MainApplication {
  //static const baseURL = kReleaseMode ? "https://v1.api.usebeelearn.com" :  "http://127.0.0.1:8000";
  static const baseURL = "https://v1.api.usebeelearn.com";

  static late SharedPreferences sharedPreferences;

  static String? firebaseIdToken, accessToken;

  static bool get isNewUser => sharedPreferences.getBool("isNewUser") ?? true;
  static set isNewUser(bool state) => sharedPreferences.setBool("isNewUser", state);

  static final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static const String appNetworkLogo = "https://res.cloudinary.com/beelearn/image/upload/v1697927475/permanent/app-logo-circle.png";

  static setUp(WidgetsBinding? widgetsBinding) async {
    if (widgetsBinding != null) {
      FlutterNativeSplash.preserve(
        widgetsBinding: widgetsBinding,
      );
    }

    MainApplication.sharedPreferences = await SharedPreferences.getInstance();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      AppLovinMAX.initialize(appLovinSdkKey);
      AwesomeNotifications().initialize(
        debug: kDebugMode,
        NotificationConstant.appIcon,
        NotificationConstant.notificationChannels,
        channelGroups: NotificationConstant.notificationChannelGroups,
      );
    }
  }

  static dispose() {
    AwesomeNotifications().dispose();
  }
}
