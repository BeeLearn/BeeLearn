import 'package:beelearn/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/user_controller.dart';

/// Notification Settings Dialog
class SettingsNotificationView extends StatelessWidget {
  const SettingsNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Consumer<UserModel>(
        builder: (context, model, child) {
          final user = model.value;

          return ListView(
            children: [
              SwitchListTile(
                title: const Text("News Letter"),
                subtitle: const Text(
                  "Receive promotional emails, new letters and social media post updates",
                ),
                onChanged: (value) async {
                  final newUser = await userController.updateUser(
                    id: user.id,
                    body: {
                      "settings": {
                        "is_promotional_email_enabled": value,
                      }
                    },
                  );

                  model.value = newUser;
                },
                value: user.settings!.isPromotionalEmailEnabled,
              ),
              const Divider(),
              SwitchListTile(
                title: const Text("Push Notifications"),
                subtitle: const Text(
                  "Receive new content alert and recommendations, following and mentions updates and more",
                ),
                onChanged: (value) async {
                  final newUser = await userController.updateUser(
                    id: user.id,
                    body: {
                      "settings": {
                        "is_push_notifications_enabled": value,
                      }
                    },
                  );

                  model.value = newUser;
                },
                value: user.settings!.isPushNotificationsEnabled,
              ),
            ],
          );
        },
      ),
    );
  }
}
