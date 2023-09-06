import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase show User;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../main_application.dart';
import '../serializers/token.dart';
import '../serializers/user.dart';
import '../socket_client.dart';

class UserModel extends ChangeNotifier {
  User? _user;

  // firebase authentication state
  String? firebaseIdToken;
  firebase.User? firebaseUser;

  /// A setter wrapper to getIdToken when firebase user is set
  Future<void> setFirebaseUser(firebase.User? user) async {
    firebaseUser = user;

    /// Todo remove
    log("firebaseUser mutated", error: user);

    final idToken = await user?.getIdToken();

    /// Todo remove
    log("idToken gotten", error: idToken);

    firebaseIdToken = idToken;
    MainApplication.accessToken = idToken;

    updateClient(idToken);
    notifyListeners();
  }

  static const String apiURL = "${MainApplication.baseURL}/api/account/users/";

  User get user => _user!;
  User? get nullableUser => _user;

  setUser(User user) {
    _user = user;
    notifyListeners();
  }

  static Future<Token> getUserToken(Map<String, dynamic> data) {
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
          return Future.error(response);
      }
    });
  }

  static Future<User> getCurrentUser() {
    return get(
      Uri.parse("${apiURL}current-user/"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then(
      (response) {
        switch (response.statusCode) {
          case HttpStatus.ok:
            return User.fromJson(jsonDecode(response.body));
          default:
            return Future.error(response);
        }
      },
    );
  }

  static Future<User> updateOne(int id, Map<String, dynamic> data) {
    return patch(
      Uri.parse("$apiURL$id/"),
      body: jsonEncode(data),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then((response) {
      switch (response.statusCode) {
        case HttpStatus.ok:
          return User.fromJson(jsonDecode(response.body));
        default:
          return Future.error(response);
      }
    });
  }
}
