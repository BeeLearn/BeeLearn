import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../main_application.dart';
import '../../models/firebase_user_model.dart';
import '../app_theme.dart';

class ApplicationFragment extends StatefulWidget {
  const ApplicationFragment({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationFragmentState();
}

class _ApplicationFragmentState extends State<ApplicationFragment> {
  StreamSubscription? idTokenSubscription, authStateChangesSubscription;

  @override
  void initState() {
    super.initState();

    idTokenSubscription = FirebaseAuth.instance.idTokenChanges().listen((user) {
      FirebaseUserModel.setup(
        context,
        user,
      );
    });

    authStateChangesSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        FirebaseUserModel.setup(
          context,
          user,
          reconnect: true,
        );
      },
    );
  }

  @override
  void dispose() {
    idTokenSubscription?.cancel();
    authStateChangesSubscription?.cancel();

    super.dispose();
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
