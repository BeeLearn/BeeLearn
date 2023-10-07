import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// global app state instance
class MainApplication {
  static const isDevelopment = false;
  static const baseURL = isDevelopment ? "http://127.0.0.1:8000" : "https://beelearn-zb6z.onrender.com";

  static late SharedPreferences sharedPreferences;
  static String? firebaseIdToken, accessToken;

  static bool get isNewUser => sharedPreferences.getBool("isNewUser") ?? true;
  static set isNewUser(bool state) => sharedPreferences.setBool("isNewUser", state);

  static final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static const String appNetworkLogo = "https://academy.usebeelearn.com/icons/Icon-192.png";
}
