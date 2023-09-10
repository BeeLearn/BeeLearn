import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show get;

import '../main_application.dart';
import '../serializers/paginate.dart';
import '../serializers/reward.dart';
import 'base_model.dart';

class RewardModel extends BaseModel<Reward> {
  @override
  getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => second.isUnlocked
      ? 1
      : first.id > second.id
          ? 0
          : -1;

  static const apiURL = "${MainApplication.baseURL}/api/reward/rewards/";

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
