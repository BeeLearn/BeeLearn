import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../controllers/notification_controller.dart';
import '../../globals.dart';
import '../../main_application.dart';
import '../../middlewares/api_middleware.dart';
import '../../middlewares/widget_middleware.dart';
import '../../mixins/initialization_state_mixin.dart';
import '../../models/user_model.dart';
import '../app_theme.dart';

/// Application state wrapper for authentication, middlewares and more
/// Todo switch to GetX to handle app state and more
class ApplicationFragment extends StatefulWidget {
  const ApplicationFragment({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationFragmentState();
}

class _ApplicationFragmentState<T extends StatefulWidget> extends State<T> with InitializationStateMixin<T> {
  late final UserModel _userModel;
  late final StreamSubscription<User?> _authStateChangeListener;

  StreamSubscription<List<PurchaseDetails>>? _purchaseUpdateListener;

  // authStateChanges must be called before app can initialize
  InitializationState appInitializationState = InitializationState.pending;

  final _awesomeNotifications = AwesomeNotifications();
  final _awesomeNotificationsFcm = AwesomeNotificationsFcm();

  @override
  void initState() {
    // make scaffold body extend to system navigationBar
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

    if (!kIsWeb && Platform.isAndroid && Platform.isIOS) {
      _purchaseUpdateListener = InAppPurchase.instance.purchaseStream.listen(
        (purchaseDetailsList) {
          for (final purchaseDetails in purchaseDetailsList) {
            switch (purchaseDetails.status) {
              case PurchaseStatus.pending:

                /// Todo update purchase status as pending
                break;
              case PurchaseStatus.purchased:
              case PurchaseStatus.restored:

                /// Todo add user as entitled when purchase is verified
                break;
              case PurchaseStatus.canceled:
              case PurchaseStatus.error:

                /// Todo remove user as entitled when purchase is cancelled or has an error
                break;
            }
          }
        },
        onDone: () => _purchaseUpdateListener?.cancel(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    _authStateChangeListener.cancel();
    _purchaseUpdateListener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    switch (appInitializationState) {
      case InitializationState.success:
        return WidgetMiddleware(
          /// Call ui initialization blocking stuffs here
          onInit: (stateNotifier) async {
            // addListener first to prevent error short circuit
            stateNotifier.addListener(
              () {
                switch (stateNotifier.value) {
                  /// Todo handle error state after splash removed
                  case InitializationState.success:
                  case InitializationState.error:
                    FlutterNativeSplash.remove();
                  default:
                    return;
                }
              },
            );

            if (MainApplication.accessToken != null) {
              ApiMiddleware.run(context);

              if (!kIsWeb) {
                await _awesomeNotificationsFcm.initialize(
                  licenseKeys: null,
                  debug: MainApplication.isDevelopment,
                  onFcmTokenHandle: NotificationController.fcmTokenHandle,
                  onFcmSilentDataHandle: NotificationController.silentDataHandle,
                  onNativeTokenHandle: NotificationController.nativeTokenHandle,
                );

                _awesomeNotifications.setListeners(
                  onActionReceivedMethod: NotificationController.onActionReceivedMethod,
                  onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
                  onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
                  onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
                );

                _awesomeNotifications.isNotificationAllowed().then((isAllowed) {
                  if (!isAllowed) {
                    // This is just a basic example. For real apps, you must show some
                    // friendly dialog box before call the request method.
                    // This is very important to not harm the user experience
                    AwesomeNotifications().requestPermissionToSendNotifications();
                  }
                });
              }
            }
          },
          builder: (context, state) => ResponsiveBreakpoints.builder(
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
