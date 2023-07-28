import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_application.dart';
import 'views/application_view.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  MainApplication.sharedPreferences = await SharedPreferences.getInstance();
  await MainApplication.preferences.clear();

  runApp(const ApplicationView());
}
