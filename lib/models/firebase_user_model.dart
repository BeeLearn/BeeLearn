import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import '../main_application.dart';
import '../middlewares/api_middleware.dart';
import 'user_model.dart';

class FirebaseUserModel {
  static Future<void>? setup(BuildContext context, User? user, {bool? reconnect}) {
    return user?.getIdToken().then(
      (value) {
        MainApplication.accessToken = value;
        if (reconnect ?? false) {
          UserModel.getCurrentUser().then((user) {
            Provider.of<UserModel>(
              context,
              listen: false,
            ).setUser(user);

            ApiMiddleware.run(context);
          });
        }
        FlutterNativeSplash.remove();
      },
    );
  }
}
