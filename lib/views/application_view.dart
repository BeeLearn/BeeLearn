import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_application.dart';
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
        "APP_LOVIN_REWARD_ADS": "",
        "APP_LOVIN_INTERSTITIAL_ADS": "",
        "APP_LOVIN_NATIVE_ADS": "",
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
