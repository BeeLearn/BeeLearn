import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uni_links/uni_links.dart';

import '../main_application.dart';
import '../models/firebase_user_model.dart';
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
    androidMinimumVersion: '4.4',
    iOSBundleId: 'com.oasis.beelearn',
    androidPackageName: 'com.oasis.beelearn',
  );

  StreamSubscription? deepLinkSubscription;

  @override
  initState() {
    super.initState();

    getInitialLink().then((String? link) {
      resolveLinkIfEmailLink(link);
    });

    if (!kIsWeb) {
      deepLinkSubscription = linkStream.listen((link) {
        resolveLinkIfEmailLink(link);
      });
    }
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

      _emailLink = link;
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
        .then((userCredential) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Wait some moment while we fetch your account"),
        ),
      );

      FirebaseUserModel.setup(
        context,
        userCredential.user,
        reconnect: true,
      )?.then((value) => context.pushReplacement("/"));
    }).onError((error, stackTrace) {
      context.loaderOverlay.hide();

      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text("Can't verify email link"),
        ),
      );
    });
  }

  Future<void> sendEmailSignInLink(String email) {
    context.loaderOverlay.show();

    return FirebaseAuth.instance.sendSignInLinkToEmail(email: email, actionCodeSettings: _actionCodeSettings).then(
      (value) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text("Email link sent to your email successfully"),
          ),
        );
      },
    ).onError((error, stackTrace) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: const Text("An error occur, Can't send email link"),
          action: SnackBarAction(
            label: "Try again",
            onPressed: () {
              sendEmailSignInLink(email);
            },
          ),
        ),
      );
    }).whenComplete(() => context.loaderOverlay.hide());
  }

  Future<void> firebaseSignIn(Future<UserCredential> signInFunction) {
    context.loaderOverlay.show();

    return signInFunction.then((userCredential) {
      FirebaseUserModel.setup(
        context,
        reconnect: true,
        userCredential.user,
      )?.then((value) => context.pushReplacement("/"));
    }).catchError((error) {
      print(error);
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("An error occur while signing up."),
        ),
      );
    }).whenComplete(() => context.loaderOverlay.hide());
  }

  Widget get footer {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
            style: TextStyle(color: Colors.grey[500]),
          ),
        ),
      ],
    );
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        width: 80,
                        height: 80,
                        image: AssetImage("assets/app_icon_dark.png"),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "Let's Start your"),
                            TextSpan(text: " fun"),
                            TextSpan(text: " &"),
                            TextSpan(text: " easy"),
                            TextSpan(text: " growth!"),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text("Sign up to personalize your experience and save your progress"),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
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
                                child: const Text("Send email link"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Row(
                          children: [
                            Expanded(child: Divider(height: 24)),
                            SizedBox(width: 4.0),
                            Text("Sign in with"),
                            SizedBox(width: 4.0),
                            Expanded(
                              child: Divider(height: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        Wrap(
                          direction: Axis.vertical,
                          spacing: 8.0,
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: () => firebaseSignIn(
                                kIsWeb ? FirebaseUserModel.signInWithGoogleWeb() : FirebaseUserModel.signInWithGoogle(),
                              ),
                              label: const Text("Continue With Google"),
                              icon: Image.asset(
                                "assets/icons/ic_google.png",
                                width: 24,
                                height: 24,
                              ),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: () => firebaseSignIn(
                                kIsWeb ? FirebaseUserModel.signInWithFacebookWeb() : FirebaseUserModel.signInWithFacebook(),
                              ),
                              label: const Text("Continue With Facebook"),
                              icon: Image.asset(
                                "assets/icons/ic_facebook.png",
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  footer,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
