import 'dart:convert';
import 'dart:io';

import 'package:beelearn/main_application.dart';
import 'package:beelearn/serializers/token.dart';
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

  static Future<Token> getOrCreateUser(Map<String, dynamic> data) {
    return post(
      Uri.parse("${apiURL}create-user/"),
      body: jsonEncode(data),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    ).then((response) {
      switch (response.statusCode) {
        case HttpStatus.ok:
          return Token.fromJson(jsonDecode(response.body));
        default:
          print(response.body);
          throw Error();
      }
    });
  }

  static Future<User> getCurrentUser() {
    return get(
      Uri.parse("${apiURL}current-user/"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then((response) {
      return User.fromJson(jsonDecode(response.body));
    });
  }

  static Future<User> updateOne(int id, Map<String, dynamic> data) {
    return patch(
      Uri.parse("$apiURL$id/"),
      body: jsonEncode(data),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then((response) {
      switch (response.statusCode) {
        case HttpStatus.ok:
          return User.fromJson(jsonDecode(response.body));
        default:
          throw Error();
      }
    });
  }
}
