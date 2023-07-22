import 'dart:convert';
import 'dart:io';

import 'package:beelearn/main_application.dart';
import 'package:beelearn/serializers/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class UserModel extends ChangeNotifier {
  User? _user;
  static const String apiURL = "${MainApplication.baseURL}/api/account/users/";

  User get user => _user!;

  setUser(User user) {
    _user = user;
    notifyListeners();
  }

  static Future<User> getCurrentUser() {
    return get(
      Uri.parse("${apiURL}current-user/"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.testAccessToken}",
      },
    ).then((response) {
      return User.fromJson(jsonDecode(response.body));
    });
  }
}
