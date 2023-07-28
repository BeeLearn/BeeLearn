import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../models/course_model.dart';
import '../models/reward_model.dart';
import '../models/streak_model.dart';
import '../models/user_model.dart';
import 'fragments/application_fragment.dart';

class ApplicationView extends StatelessWidget {
  const ApplicationView({super.key});

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
      ],
      child: const ApplicationFragment(),
    );
  }
}
