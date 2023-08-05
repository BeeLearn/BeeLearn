import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../main_application.dart';
import '../../middlewares/api_middleware.dart';
import '../app_theme.dart';

class ApplicationFragment extends StatefulWidget {
  const ApplicationFragment({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationFragmentState();
}

class _ApplicationFragmentState extends State<ApplicationFragment> {
  @override
  void initState() {
    super.initState();
    if (MainApplication.accessToken != null) {
      ApiMiddleware.run(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.dark,
      scaffoldMessengerKey: MainApplication.scaffoldKey,
      home: Scaffold(
        body: MaterialApp.router(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          routerConfig: router,
        ),
      ),
    );
  }
}
