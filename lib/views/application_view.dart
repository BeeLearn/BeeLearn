import 'dart:async';
import 'dart:developer';

import 'package:beelearn/constants/constants.dart';
import 'package:beelearn/views/email_link_login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import '../main_application.dart';
import '../middlewares/api_middleware.dart';
import '../models/models.dart';
import 'app_theme.dart';
import 'fragments/application_fragment.dart';

class ApplicationView extends StatefulWidget {
  const ApplicationView({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationViewState();
}

class _ApplicationViewState extends State<ApplicationView> {
  late final FirebaseRemoteConfig _remoteConfig;
  StreamSubscription? _remoteConfigSubscription;

  @override
  void initState() {
    super.initState();
    _remoteConfig = FirebaseRemoteConfig.instance;
    _remoteConfig.setDefaults(
      {
        "APP_LOVIN_REWARD_AD": appLovinRewardAd,
        "APP_LOVIN_INTERSTITIAL_AD": appLovinInterstitialAd,
        "APP_LOVIN_NATIVE_AD": "",
        "FLUTTER_PUBLIC_KEY": flutterPublicKey,
        "PAYSTACK_PUBLIC_KEY": paystackPublicKey,
      },
    );

    if (!kIsWeb) {
      _remoteConfigSubscription = _remoteConfig.onConfigUpdated.listen(
        (event) => _remoteConfig.activate(),
      );
    }

    /// Lazy load remote configs
    _remoteConfig.fetchAndActivate();
  }

  @override
  void dispose() {
    super.dispose();
    _remoteConfigSubscription?.cancel();
  }

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryModel()),
        ChangeNotifierProvider(create: (context) => NewCourseModel()),
        ChangeNotifierProvider(create: (context) => InProgressCourseModel()),
        ChangeNotifierProvider(create: (context) => CompletedCourseModel()),
        ChangeNotifierProvider(create: (context) => RewardModel()),
        ChangeNotifierProvider(create: (context) => StreakModel()),
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => FavouriteCourseModel()),
        ChangeNotifierProvider(create: (context) => PurchaseModel()),
        ChangeNotifierProvider(create: (context) => ProductModel()),
        ChangeNotifierProvider(create: (context) => NotificationModel()),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        scaffoldMessengerKey: MainApplication.scaffoldKey,
        home: const Scaffold(
          body: ApplicationFragment(),
        ),
      ),
    );
  }
}
