import 'dart:developer';

import 'package:flutter/material.dart' hide OutlinedButton;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../controllers/firebase_auth_controller.dart';
import '../models/user_model.dart';
import 'components/buttons.dart';

@immutable
class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingView();
}

class _OnBoardingView extends State<OnBoardingView> {
  final isLoading = ValueNotifier(false);

  late final UserModel _userModel;

  @override
  initState() {
    super.initState();

    _userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );
    _userModel.addListener(_userUpdateListener);
  }

  @override
  dispose() {
    super.dispose();

    _userModel.removeListener(_userUpdateListener);
  }

  _userUpdateListener() {
    if (_userModel.nullableValue != null) context.go("/");
  }

  _signInWithGoogle(BuildContext context) {
    isLoading.value = true;
    context.loaderOverlay.show();

    firebaseAuthController.signInWithGoogle().onError((error, stackTrace) {
      // Get.showSnackbar(
      //   const GetSnackBar(
      //     message: "An unexpected error occur, Try again!",
      //   ),
      // );

      log("Firebase error", error: error, stackTrace: stackTrace);

      return Future.error(() => error);
    }).whenComplete(() => context.loaderOverlay.hide());
  }

  _signInWithFacebook(BuildContext context) {
    isLoading.value = true;
    context.loaderOverlay.show();

    firebaseAuthController.signInWithFacebook().onError((error, stackTrace) {
      // Get.showSnackbar(
      //   const GetSnackBar(
      //     message: "An unexpected error occur, Try again!",
      //   ),
      // );

      return Future.error(() => error);
    }).whenComplete(() => context.loaderOverlay.hide());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      minRadius: 32,
                      child: Image.asset(
                        Theme.of(context).brightness == Brightness.dark ? "assets/app_icon_dark.png" : "assets/app_icon_light.png",
                        width: 48,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Column(
                      children: [
                        Text(
                          "Get started!",
                          style: GoogleFonts.nunitoSans(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          "Join our amazing community of education lovers",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton.icon(
                        onPressed: () => _signInWithGoogle(context),
                        icon: Image.asset(
                          "assets/icons/ic_google.png",
                          width: 24.0,
                        ),
                        label: const Center(
                          child: Text("Continue with Google"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton.icon(
                        onPressed: () => _signInWithFacebook(context),
                        icon: Image.asset(
                          "assets/icons/ic_facebook.png",
                          width: 24.0,
                        ),
                        label: const Center(
                          child: Text("Continue with Facebook"),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Continue as anonymous user",
                    style: GoogleFonts.albertSans(),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
