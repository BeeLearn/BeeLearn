import 'package:beelearn/views/fragments/topic_fragment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import '../models/topic_model.dart';

class TopicView extends StatelessWidget {
  final int lessonId;

  const TopicView({
    super.key,
    required this.lessonId,
  });

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TopicModel(),
        ),
      ],
      child: TopicFragment(lessonId: lessonId),
    );
  }
}
