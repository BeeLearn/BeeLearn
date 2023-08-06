import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';
import '../../main_application.dart';
import '../../middlewares/api_middleware.dart';
import '../../models/user_model.dart';
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

    FirebaseAuth.instance.idTokenChanges().listen((idToken) {
      MainApplication.accessToken = idToken;
    });

    FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        user?.getIdToken().then(
          (value) {
            MainApplication.accessToken = value;
            UserModel.getCurrentUser().then((user) {
              Provider.of<UserModel>(
                context,
                listen: false,
              ).setUser(user);
              ApiMiddleware.run(context);

              FlutterNativeSplash.remove();
            });
          },
        );
      },
    );
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
