import 'dart:developer';

import 'package:beelearn/models/value_change_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase show User;

import '../main_application.dart';
import '../serializers/user.dart';
import '../socket_client.dart';

class UserModel extends ValueChangeNotifier<User> {
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
}
