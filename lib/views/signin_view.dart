import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../main_application.dart';
import 'app_theme.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();

  final _emailInputController = TextEditingController();
  final _passwordInputController = TextEditingController();

  @override
  Widget build(context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
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
                          const SizedBox(height: 16.0),
                          TextFormField(
                            obscureText: true,
                            controller: _passwordInputController,
                            validator: ValidationBuilder().minLength(6).build(),
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock_rounded),
                              hintText: "Password",
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          FilledButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                context.loaderOverlay.show();

                                final email = _emailInputController.text;
                                final password = _passwordInputController.text;

                                await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then(
                                  (userCredential) {
                                    userCredential.user?.getIdToken().then(
                                      (idToken) {
                                        MainApplication.accessToken = idToken;
                                      },
                                    );
                                    print(MainApplication.accessToken);
                                    context.pushReplacement("/");
                                  },
                                ).catchError(
                                  (error, stackTrace) {
                                    print(error);
                                  },
                                ).whenComplete(() => context.loaderOverlay.hide());
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
