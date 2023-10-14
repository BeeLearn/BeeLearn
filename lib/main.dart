import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'main_application.dart';
import 'constants/constants.dart';
import 'views/application_view.dart';

/// Main application entry
/// Wrapped round sentry to catch runtime exceptions
void main() async {
  await SentryFlutter.init(
    (options) {
      options.tracesSampleRate = 1.0;
      options.dsn = sentryDns;
    },
    appRunner: () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      await MainApplication.setUp(widgetsBinding);
      runApp(const ApplicationView());
    },
  );
}
