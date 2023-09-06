import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../globals.dart';
import '../../main_application.dart';
import '../../middlewares/api_middleware.dart';
import '../../middlewares/widget_middleware.dart';
import '../../mixins/initialization_state_mixin.dart';
import '../../models/user_model.dart';
import '../app_theme.dart';

class ApplicationFragment extends StatefulWidget {
  const ApplicationFragment({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationFragmentState();
}

class _ApplicationFragmentState<T extends StatefulWidget> extends State<T> with InitializationStateMixin<T> {
  late final UserModel _userModel;
  late final StreamSubscription<User?> _idTokenListener, _authStateChangeListener;

  // authStateChanges must be called before app can initialize
  InitializationState appInitializationState = InitializationState.pending;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.initState();
  }

  @override
  Future<void> initialize() async {
    _userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    _authStateChangeListener = FirebaseAuth.instance.authStateChanges().listen(
      (user) async {
        await _userModel.setFirebaseUser(user);
        setState(
          () {
            appInitializationState = InitializationState.success;
          },
        );
      },
    );

    _idTokenListener = FirebaseAuth.instance.idTokenChanges().listen(
      (user) async {
        _userModel.firebaseUser = user;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    _idTokenListener.cancel();
    _authStateChangeListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    switch (appInitializationState) {
      case InitializationState.success:
        return WidgetMiddleware(
          onInit: (stateNotifier) async {
            if (MainApplication.accessToken != null) {
              ApiMiddleware.run(context);
              final user = await UserModel.getCurrentUser();
              _userModel.setUser(user);
            }

            stateNotifier.addListener(
              () {
                switch (stateNotifier.value) {
                  case InitializationState.success:
                  case InitializationState.error:
                    FlutterNativeSplash.remove();
                  default:
                    return;
                }
              },
            );
          },
          builder: (state) => ResponsiveBreakpoints.builder(
            breakpoints: defaultBreakpoints,
            child: MaterialApp.router(
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              routerConfig: router,
            ),
          ),
        );
      case InitializationState.idle:
      case InitializationState.pending:
        return const Center(
          child: CircularProgressIndicator(),
        );

      default:
        throw UnimplementedError("appInitializationState don't implements $appInitializationState");
    }
  }
}
