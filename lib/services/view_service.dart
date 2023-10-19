import 'package:beelearn/widget_keys.dart';
import 'package:flutter/material.dart';

import '../views/settings_premium_view.dart';

class ViewService {
  static Future<T?> showPremiumDialog<T>(BuildContext context) async {
    return showDialog<T>(
      useSafeArea: false,
      context: context,
      builder: (buildContext) {
        return const SettingsPremiumView(key: premiumSettingsViewKey);
      },
    );
  }
}
