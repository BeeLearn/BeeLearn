import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../models/firebase_user_model.dart';
import 'app_theme.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();

  final _emailInputController = TextEditingController();
  final _passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: LoaderOverlay(
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: context.pop,
            ),
          ),
          body: LayoutBuilder(
            builder: (context, viewportConstraint) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
                  bottom: 8.0,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraint.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Image(
                          height: 88,
                          width: 88,
                          image: AssetImage("assets/app_icon_dark.png"),
                        ),
                        Expanded(
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
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.loaderOverlay.show();

                                      final email = _emailInputController.text;
                                      final password = _passwordInputController.text;

                                      FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      )
                                          .onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Can't login, check your details and try again!",
                                            ),
                                          ),
                                        );

                                        return Future.error(error ?? Error());
                                      }).then((userCredential) {
                                        ScaffoldMessenger.of(context).showSnackBar(
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
                                      }).whenComplete(() => context.loaderOverlay.hide());
                                    }
                                  },
                                  child: const Text("Login to account"),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// What this to add weight to both up and down while can scroll all as one
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
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
