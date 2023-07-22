import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:beelearn/main_application.dart';
import 'package:beelearn/serializers/paginate.dart';
import 'package:beelearn/serializers/reward.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:http/http.dart' show get;

class RewardModel extends ChangeNotifier {
  List<Reward> _rewards = [];
  static const apiURL = "${MainApplication.baseURL}/api/reward/rewards/";

  UnmodifiableListView<Reward> get rewards => UnmodifiableListView(_rewards);

  setAll(List<Reward> rewards) {
    _rewards = rewards;
    notifyListeners();
  }

  addAll(List<Reward> rewards) {
    _rewards.addAll(rewards);
    notifyListeners();
  }

  static Future<Paginate<Reward>> getRewards({String? nextURL}) {
    return get(Uri.parse(nextURL ?? apiURL), headers: {
      HttpHeaders.authorizationHeader: "Token ${MainApplication.testAccessToken}",
    }).then((response) {
      return Paginate.fromJson(
        jsonDecode(response.body),
        Reward.fromJson,
      );
    });
  }
}
