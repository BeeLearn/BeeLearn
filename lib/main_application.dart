import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainApplication {
  static const baseURL = "https://beelearn.onrender.com";
  static SharedPreferences? sharedPreferences;
  static String? get accessToken => preferences.getString("accessToken");

  static set accessToken(token) {
    preferences.setString("accessToken", token);
  }

  static final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static SharedPreferences get preferences => sharedPreferences!;
}
