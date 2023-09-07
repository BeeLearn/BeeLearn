import 'package:beelearn/views/settings_edit_profile.dart';
import 'package:beelearn/views/settings_notifications_view.dart';
import 'package:beelearn/views/settings_premium_view.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                direction: Axis.vertical,
                children: [
                  ListTile(
                    leading: const CircleAvatar(),
                    onTap: () {
                      showDialog(
                        useSafeArea: false,
                        context: context,
                        builder: (context) => const SettingsEditProfile(),
                      );
                    },
                    title: Text(
                      "LyonKvalid",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Student"),
                        Text(
                          "Logged in with Google",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).hintColor : null,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        useSafeArea: false,
                        context: context,
                        builder: (context) => const SettingsPremiumView(),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              const TextSpan(
                                children: [
                                  TextSpan(text: "You're not "),
                                  TextSpan(
                                    text: "Premium",
                                    style: TextStyle(fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.diamond,
                                color: Theme.of(context).colorScheme.primaryContainer,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Customize",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    children: [
                      ListTile(
                        title: const Text("Notifications"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (context) => const SettingsNotificationView(),
                          );
                        },
                      ),
                      const Divider(),
                      const ListTile(
                        title: Text("Terms and Conditions"),
                        trailing: Icon(Icons.output),
                      ),
                      const Divider(),
                      const ListTile(
                        title: Text("Report content"),
                        trailing: Icon(Icons.output),
                      ),
                      const Divider(),
                      const ListTile(
                        title: Text("FAQ"),
                        trailing: Icon(Icons.output),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
