import 'package:beelearn/views/fragments/module_fragment.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/module_model.dart';
import 'app_theme.dart';

class ModuleView extends StatelessWidget {
  final int courseId;
  final String? courseName;

  const ModuleView({
    super.key,
    this.courseName,
    required this.courseId,
  });

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ModuleModel()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: context.pop),
            title: Text(courseName ?? ""),
          ),
          body: ModuleFragment(courseId: courseId),
        ),
      ),
    );
  }
}
