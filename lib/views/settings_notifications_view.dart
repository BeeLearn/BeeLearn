import 'package:beelearn/widget_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/user_controller.dart';
import '../models/models.dart';
import 'fragments/dialog_fragment.dart';

/// Notification Settings Dialog
class SettingsNotificationView extends StatelessWidget {
  const SettingsNotificationView({super.key});

  Widget _getBody(BuildContext context) {
    final userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(key: notificationSettingsViewBackButtonKey),
        title: const Text("Notifications"),
      ),
      body: Selector<UserModel, (bool, bool)>(
        selector: (context, model) => (
          model.value.settings!.isPromotionalEmailEnabled,
          model.value.settings!.isPushNotificationsEnabled,
        ),
        builder: (context, data, child) {
          final (isPromotionalEmailEnabled, isPushNotificationsEnabled) = data;

          return ListView(
            children: [
              SwitchListTile(
                title: const Text("News Letter"),
                subtitle: const Text(
                  "Receive promotional emails, new letters and social media post updates",
                ),
                onChanged: (value) async {
                  final user = userModel.value;

                  // Lazy update
                  userController.updateUser(
                    id: user.id,
                    body: {
                      "settings": {
                        "is_promotional_email_enabled": value,
                      }
                    },
                  );
                  user.settings!.isPromotionalEmailEnabled = value;
                  userModel.value = user;
                },
                value: isPromotionalEmailEnabled,
              ),
              const Divider(),
              SwitchListTile(
                title: const Text("Push Notifications"),
                subtitle: const Text(
                  "Receive new content alert and recommendations, following and mentions updates and more",
                ),
                onChanged: (value) async {
                  final user = userModel.value;

                  // Lazy update
                  userController.updateUser(
                    id: user.id,
                    body: {
                      "settings": {
                        "is_push_notifications_enabled": value,
                      }
                    },
                  );

                  user.settings!.isPushNotificationsEnabled = value;
                  userModel.value = user;
                },
                value: isPushNotificationsEnabled,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogFragment(
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.topRight,
      builder: _getBody,
    );
  }
}
