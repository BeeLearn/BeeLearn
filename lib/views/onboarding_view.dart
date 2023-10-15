import 'dart:async';
import 'dart:developer';

import 'package:beelearn/widget_keys.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide OutlinedButton;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uni_links/uni_links.dart';

import '../controllers/firebase_auth_controller.dart';
import '../main_application.dart';
import '../middlewares/api_middleware.dart';
import '../models/user_model.dart';
import 'components/buttons.dart';
import 'email_link_login_view.dart';

@immutable
class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingView();
}

class _OnBoardingView extends State<OnBoardingView> with AutomaticKeepAliveClientMixin {
  late final UserModel _userModel;
  final isLoading = ValueNotifier(false);

  int currentCarouselIndex = 0;
  late final StreamSubscription<String?> _uniLinkListener;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();

    _userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    _userModel.addListener(_userUpdateListener);

    initialize().onError(
      (error, stackTrace) => log(
        "Fucked me",
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  Future<void> initialize() async {
    try {
      final initialLink = await getInitialLink();

      if (initialLink != null && FirebaseAuth.instance.isSignInWithEmailLink(initialLink)) {
        await _signInWithEmailLink(link: initialLink);
      }
    } on PlatformException {
      showSnackBar(
        leading: const Icon(
          Icons.error,
          color: Colors.redAccent,
        ),
        title: "You can't login using magic link om this device",
      );
    }

    _uniLinkListener = linkStream.listen(
      (String? link) async {
        if (link != null && FirebaseAuth.instance.isSignInWithEmailLink(link)) {
          await _signInWithEmailLink(link: link);
        }
      },
      onError: (err) {},
    );
  }

  Future<void> _signInWithEmailLink({
    String? email,
    required String link,
  }) async {
    context.loaderOverlay.show();
    email = email ?? MainApplication.sharedPreferences.getString("local.USER_EMAIL");
    email ??= await showDialog<String>(
      context: context,
      useSafeArea: false,
      builder: (context) => const EmailLinkLoginView(requestEmail: true),
    );

    try {
      if (email != null) {
        FirebaseAuth.instance.signInWithEmailLink(
          email: email,
          emailLink: link,
        );
      } else {
        context.loaderOverlay.hide();
      }
    } on FirebaseAuthException catch (error) {
      context.loaderOverlay.hide();

      late final String errorMessage;

      switch (error.code) {
        case "firebase_auth/invalid":
          errorMessage = "Invalid magic link.";
        default:
          errorMessage = "An unexpected error occurred. Try again!";
      }

      showSnackBar(
        leading: const Icon(
          Icons.error,
          color: Colors.redAccent,
        ),
        title: errorMessage,
      );

      rethrow;
    }
  }

  @override
  dispose() {
    super.dispose();

    _uniLinkListener.cancel();
    _userModel.removeListener(_userUpdateListener);
  }

  _userUpdateListener() {
    context.loaderOverlay.hide();
    if (_userModel.nullableValue != null) context.go("/");
  }

  Future<UserCredential> _signInWithGoogle(BuildContext context) async {
    isLoading.value = true;
    context.loaderOverlay.show();

    return firebaseAuthController.signInWithGoogle().onError(
      (dynamic error, stackTrace) {
        context.loaderOverlay.hide();

        return Future.error(error!);
      },
    );
  }

  Future<UserCredential> _signInWithFacebook(BuildContext context) async {
    isLoading.value = true;
    context.loaderOverlay.show();

    return firebaseAuthController.signInWithFacebook().onError((error, stackTrace) {
      context.loaderOverlay.hide();
      return Future.error(() => error);
    });
  }

  Widget get _mainBodyHeader {
    return Center(
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
    );
  }

  Widget get _mainBodySection {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomOutlinedButton.icon(
                key: onBoardingViewGoogleSignInButtonKey,
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
                key: onBoardingViewFacebookSignInButtonKey,
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
        const SizedBox(height: 24),
        TextButton(
          key: onBoardingViewEmailSignInButtonKey,
          onPressed: () {
            showDialog(
              context: context,
              useSafeArea: false,
              builder: (context) => const EmailLinkLoginView(),
            );
          },
          child: const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "or "),
                TextSpan(
                  text: "use your email",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget get _mainBodySmall {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            child: _mainBodyHeader,
          ),
          _mainBodySection,
        ],
      ),
    );
  }

  Widget get _mainBodyLarge {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _mainBodyHeader,
            _mainBodySection,
          ],
        ),
      ),
    );
  }

  Widget _buildSideView({
    required Color backgroundColor,
    required String illustration,
    required String title,
    required String description,
  }) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: backgroundColor,
            child: Image.asset(
              illustration,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
                top: 24.0,
              ),
              child: Wrap(
                runSpacing: 4.0,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Flex(
        direction: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? Axis.horizontal : Axis.vertical,
        children: [
          Flexible(
            child: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? _mainBodyLarge : _mainBodySmall,
          ),
          if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET))
            Flexible(
              flex: 1,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    child: PageView(
                      onPageChanged: (index) {
                        setState(() => currentCarouselIndex = index);
                      },
                      children: [
                        _buildSideView(
                          backgroundColor: Colors.greenAccent,
                          illustration: "assets/illustrations/il_onboarding_intro.png",
                          title: "Practice on the go",
                          description: "BeeLearn is a practice app. "
                              "While you need to get access to the internet to access course content, "
                              "you can practice and review concepts on the go.",
                        ),
                        _buildSideView(
                            backgroundColor: Colors.amber,
                            illustration: "assets/illustrations/il_onboarding_intro_images_streak.png",
                            title: "Maintain your streak",
                            description: "Meet your weekly target or maintain a learning streak when "
                                "you practice in the app. Your progress syncs with your process on web."),
                        _buildSideView(
                            backgroundColor: Colors.purpleAccent,
                            illustration: "assets/illustrations/il_onboarding_intro_desktoptablet.png",
                            title: "Join use to learn with beelearn for free",
                            description: "Whether you have zero experience, some knowledge. or have "
                                "a good grasp on coding, we have lessons and resources for wherever you're at."),
                      ],
                    ),
                  ),
                  DotsIndicator(
                    dotsCount: 3,
                    position: currentCarouselIndex,
                    decorator: DotsDecorator(
                      activeColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 56.0),
                ],
              ),
            )
        ],
      ),
    );
  }
}
