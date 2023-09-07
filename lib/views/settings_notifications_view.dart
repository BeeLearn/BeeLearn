import 'package:flutter/material.dart';

class SettingsNotificationView extends StatelessWidget {
  const SettingsNotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("News Letter"),
            subtitle: const Text(
              "Receive promotional emails, new letters and social media post updates",
            ),
            onChanged: (data) {},
            value: true,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Push Notifications"),
            subtitle: const Text(
              "Receive new content alert and recommendations, following and mentions updates and more",
            ),
            onChanged: (data) {},
            value: true,
          ),
        ],
      ),
    );
  }
}
