import 'dart:async';

import 'package:beelearn/main_application.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uni_links/uni_links.dart';

import 'app_theme.dart';

class PasswordLessSignInView extends StatefulWidget {
  const PasswordLessSignInView({super.key});

  @override
  State createState() => _PasswordLessSignInViewState();
}

class _PasswordLessSignInViewState extends State<PasswordLessSignInView> {
  final _formKey = GlobalKey<FormState>();
  final _emailInputController = TextEditingController();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  late String _emailLink;
  bool _isRequestingEmail = false;

  final _actionCodeSettings = ActionCodeSettings(
    url: 'https://bee-learn.web.app/sign-in/?from=mobile',
    handleCodeInApp: true,
    iOSBundleId: 'com.oasis.beelearn',
    androidPackageName: 'com.oasis.beelearn',
    androidMinimumVersion: '4.4',
  );

  StreamSubscription? deepLinkSubscription;

  @override
  initState() {
    super.initState();

    getInitialLink().then((String? link) {
      print(link);
      resolveLinkIfEmailLink(link);
    });

    deepLinkSubscription = linkStream.listen((link) {
      resolveLinkIfEmailLink(link);
    });
  }

  @override
  dispose() {
    deepLinkSubscription?.cancel();
    super.dispose();
  }

  resolveLinkIfEmailLink(String? link) {
    if (link != null && FirebaseAuth.instance.isSignInWithEmailLink(link)) {
      final email = MainApplication.preferences.getString("userEmail");

      // Handle scenario whereby user is redirect from web when logging in
      if (email == null) {
        setState(() {
          _isRequestingEmail = true;
        });

        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Enter your email address"),
          ),
        );
      }

      _emailLink = link!;
      verifyEmailSignInLink(email!);
    }
  }

  verifyEmailSignInLink(String email) {
    context.loaderOverlay.show();

    return FirebaseAuth.instance
        .signInWithEmailLink(
      email: email,
      emailLink: _emailLink,
    )
        .then((userCredentials) {
      context.pushReplacement("/");
    }).onError((error, stackTrace) {
      context.loaderOverlay.hide();

      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text("Can't verify email link"),
        ),
      );
    });
  }

  sendEmailSignInLink(String email) {
    context.loaderOverlay.show();

    return FirebaseAuth.instance
        .sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: _actionCodeSettings,
    )
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email link sent to your email successfully"),
          ),
        );
      },
    ).whenComplete(() => context.loaderOverlay.hide());
  }

  @override
  Widget build(context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: LoaderOverlay(
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  const Image(
                    height: 100,
                    width: 100,
                    image: AssetImage("assets/splash_icon.png"),
                  ),
                  Flexible(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _emailInputController,
                            validator: ValidationBuilder().email().build(),
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_rounded),
                              hintText: "Email address",
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          FilledButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailInputController.text;
                                MainApplication.preferences.setString("userEmail", email);

                                if (_isRequestingEmail) {
                                  verifyEmailSignInLink(email);
                                } else {
                                  sendEmailSignInLink(email);
                                }
                              }
                            },
                            child: const Text("Login to account"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        height: 28,
                        width: 28,
                        image: AssetImage("assets/images/tidb_brand.png"),
                      ),
                      SizedBox(width: 8.0),
                      Text("Built With TIDB Cloud"),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Flexible(
                        child: Text.rich(
                          const TextSpan(
                            children: [
                              TextSpan(text: "By using BeeLearn, you agree to its "),
                              TextSpan(
                                text: "Terms Of Service",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}