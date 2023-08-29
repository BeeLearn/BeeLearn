import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'main_application.dart';
import 'views/application_view.dart';

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

      MobileAds.instance.initialize();
      runApp(const ApplicationView());
    },
  );
}
