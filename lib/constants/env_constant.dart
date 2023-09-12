import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConstant {
  static String sentryDns = dotenv.env['SENTRY_DNS']!;
  static final appLovinSdkKey = dotenv.env["APP_LOVIN_SDK_KEY"]!;
}
