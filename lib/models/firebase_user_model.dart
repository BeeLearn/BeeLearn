import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main_application.dart';

class FirebaseUserModel {
  static Future<void>? setup(BuildContext context, User? user, {bool? reconnect}) {
    return user?.getIdToken().then(
      (value) {
        MainApplication.accessToken = value;

        // This is called when app if first initialized
        if (reconnect ?? false) {
          // UserModel.getCurrentUser().then((user) {
          //   Provider.of<UserModel>(
          //     context,
          //     listen: false,
          //   ).user = user;
          //
          //   ApiMiddleware.run(context);
          // });
        }

        // Remove splash screen
        FlutterNativeSplash.remove();
      },
    );
  }

  static Future<UserCredential> signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    return FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<UserCredential> signInWithFacebookWeb() async {
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    return FirebaseAuth.instance.signInWithPopup(facebookProvider);
  }

  static Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
