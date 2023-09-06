import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/module_model.dart';
import 'fragments/module_fragment.dart';

class ModuleView extends StatelessWidget {
  final Map<String, dynamic> query;
  final String? courseName;

  const ModuleView({
    super.key,
    this.courseName,
    required this.query,
  });

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ModuleModel()),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: BackButton(onPressed: context.pop),
          title: Text(courseName ?? ""),
        ),
        body: ModuleFragment(query: query),
      ),
    );
  }
}
