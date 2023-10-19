import 'package:beelearn/widget_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../services/view_service.dart';
import '../../views/fragments/dialog_fragment.dart';
import '../../views/settings_notifications_view.dart';
import 'settings_edit_profile.dart';

/// Settings Page
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Widget _getBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(key: settingsViewBackButtonKey),
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
                  Selector<UserModel, (String, String, String, String)>(
                    selector: (context, model) {
                      final user = model.value;
                      return (
                        user.avatar,
                        user.fullName,
                        user.userType.name,
                        model.firebaseUser!.email!,
                      );
                    },
                    builder: (context, tuple, child) {
                      final (avatar, fullName, userType, email) = tuple;

                      return ListTile(
                        key: editProfileActionKey,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            avatar,
                            width: 48.0,
                            height: 48.0,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (context) => const SettingsEditProfile(key: editProfileViewKey),
                          );
                        },
                        title: Text(
                          fullName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userType.toUpperCase()),
                            Text(
                              email,
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).hintColor : null,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  InkWell(
                    key: premiumSettingsActionKey,
                    onTap: () => ViewService.showPremiumDialog(context),
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
                            child: Selector<UserModel, bool>(
                              selector: (context, model) => model.value.isPremium,
                              builder: (context, isPremium, child) {
                                return Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: isPremium ? "You're " : "You're not "),
                                      const TextSpan(
                                        text: "Premium",
                                        style: TextStyle(fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                                );
                              },
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
              const SizedBox(height: 16.0),
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
                        key: notificationSettingsActionKey,
                        title: const Text("Notifications"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (context) => const SettingsNotificationView(key: notificationModalViewKey),
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

  @override
  Widget build(BuildContext context) {
    return DialogFragment(
      alignment: Alignment.topRight,
      insetPadding: EdgeInsets.zero,
      builder: _getBody,
    );
  }
}
