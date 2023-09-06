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
            subtitle: Text(
              "Receive promotional emails, new letters and social media post updates",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[400],
                  ),
            ),
            onChanged: (data) {},
            value: true,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Push Notifications"),
            subtitle: Text(
              "Receive new content alert and recommendations, following and mentions updates and more",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[400],
                  ),
            ),
            onChanged: (data) {},
            value: true,
          ),
        ],
      ),
    );
  }
}
