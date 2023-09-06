import 'dart:async';

import 'package:beelearn/models/streak_model.dart';
import 'package:beelearn/models/user_model.dart';
import 'package:beelearn/views/fragments/topic_fragment.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import "package:provider/provider.dart";

import '../models/topic_model.dart';

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

class _TopicViewState extends State<TopicView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    final streakModel = Provider.of<StreakModel>(
      context,
      listen: false,
    );

    if (!streakModel.todayStreak.isComplete) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) async {
          UserModel userModel = Provider.of<UserModel>(
            context,
            listen: false,
          );

          /// Increment dailyStreakSeconds
          int currentStreakSeconds = await userModel.user.increaseDailyStreakSeconds(context);

          /// cancel timer when streak minute reached
          if (currentStreakSeconds >= userModel.user.profile.dailyStreakSeconds) {
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
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LoaderOverlay(
        closeOnBackButton: true,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => TopicModel(),
            ),
          ],
          child: SafeArea(
            bottom: false,
            child: TopicFragment(query: widget.query),
          ),
        ),
      ),
    );
  }
}
