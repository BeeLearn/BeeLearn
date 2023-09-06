import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:http/http.dart' show get;

import '../main_application.dart';
import '../serializers/paginate.dart';
import '../serializers/reward.dart';

class RewardModel extends ChangeNotifier {
  List<Reward> _rewards = [];
  static const apiURL = "${MainApplication.baseURL}/api/reward/rewards/";

  UnmodifiableListView<Reward> get rewards => UnmodifiableListView(_rewards);

  void setAll(List<Reward> rewards) {
    _rewards = rewards;
    notifyListeners();
  }

  void addAll(List<Reward> rewards) {
    _rewards.addAll(rewards);
    notifyListeners();
  }

  void updateOrAddOne(Reward reward) {
    final index = _rewards.indexWhere((element) => element.id == reward.id);

    if (index < 0) {
      _rewards.add(reward);
    } else {
      rewards[index] = reward;
    }

    notifyListeners();
  }

  static Future<Paginate<Reward>> getRewards({String? nextURL, Map<String, dynamic>? query}) {
    return get(
      Uri.parse(nextURL ?? apiURL).replace(queryParameters: query),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then(
      (response) {
        switch (response.statusCode) {
          case HttpStatus.ok:
            return Paginate.fromJson(
              jsonDecode(response.body),
              Reward.fromJson,
            );
          default:
            return Future.error(response);
        }
      },
    );
  }
}
