import 'dart:async';

import 'package:beelearn/models/user_model.dart';
import 'package:beelearn/views/fragments/topic_fragment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        UserModel userModel = Provider.of<UserModel>(
          context,
          listen: false,
        );

        /// Increment dailyStreakSeconds
        int currentStreakSeconds = await userModel.user.increaseDailyStreakSeconds(context);

        // cancel timer when streak minute reached
        if (currentStreakSeconds >= userModel.user.profile.dailyStreakSeconds) {
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TopicModel(),
        ),
      ],
      child: TopicFragment(query: widget.query),
    );
  }
}
