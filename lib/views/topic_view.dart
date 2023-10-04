import 'dart:async';

import 'package:beelearn/services/ad_loader.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import "package:provider/provider.dart";
import 'package:responsive_framework/responsive_breakpoints.dart';

import '../../globals.dart';
import '../models/streak_model.dart';
import '../models/topic_model.dart';
import '../models/user_model.dart';
import 'fragments/topic_fragment.dart';

/// [query] used to filter topics from api
class TopicView extends StatefulWidget {
  final Map<String, dynamic> query;

  const TopicView({
    super.key,
    required this.query,
  });

  @override
  State createState() => _TopicViewState();
}

/// Todo don't show ads if premium user
class _TopicViewState extends State<TopicView> {
  Timer? _timer;

  late final String _adUnitId;
  late final UserModel _userModel;
  late final StreakModel _streakModel;
  InterstitialAdLoader? _interstitialAdLoader;

  @override
  void initState() {
    super.initState();

    _streakModel = Provider.of<StreakModel>(
      context,
      listen: false,
    );

    _userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    _adUnitId = FirebaseRemoteConfig.instance.getString("APP_LOVIN_INTERSTITIAL_AD");

    if (!_userModel.value.isPremium) {
      _interstitialAdLoader = InterstitialAdLoader()
        ..setAdListener()
        ..loadAd(_adUnitId);
    }

    if (!_streakModel.todayStreak.isComplete) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) async {
          UserModel userModel = Provider.of<UserModel>(
            context,
            listen: false,
          );

          /// Increment dailyStreakSeconds
          int currentStreakSeconds = await userModel.value.increaseDailyStreakSeconds(context);

          /// cancel timer when streak minute reached
          if (currentStreakSeconds >= userModel.value.profile!.dailyStreakSeconds) {
            timer.cancel();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () async {
        _interstitialAdLoader?.showAd(_adUnitId);
        return true;
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: LoaderOverlay(
          closeOnBackButton: true,
          overlayOpacity: 1,
          overlayColor: Colors.black45,
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => TopicModel(),
              ),
            ],
            child: SafeArea(
              bottom: false,
              child: ResponsiveBreakpoints(
                breakpoints: defaultBreakpoints,
                child: TopicFragment(query: widget.query),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
