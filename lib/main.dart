import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'main_application.dart';
import 'models/user_model.dart';
import 'views/application_view.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  MainApplication.sharedPreferences = await SharedPreferences.getInstance();
  await MainApplication.preferences.clear();

  if (MainApplication.accessToken == null) {
    await UserModel.getOrCreateUser({"device_id": const Uuid().v4()}).then(
      (token) {
        MainApplication.accessToken = token.key;
      },
    );
  }


  await SentryFlutter.init((options) {
      options.dsn = 'https://4d8cc37455e948168ef47d19b80aa79c@o4504537892192256.ingest.sentry.io/4505607252738048';

      options.tracesSampleRate = 1.0;
    },
    appRunner: () =>   runApp(const ApplicationView()),
  );
}
