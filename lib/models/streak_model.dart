import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:beelearn/main_application.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show get, patch;

import '../serializers/paginate.dart';
import '../serializers/streak.dart';

class StreakModel extends ChangeNotifier {
  List<Streak> _streaks = [];
  static const apiURL = "${MainApplication.baseURL}/api/reward/streaks/";

  Streak get todayStreak => _streaks.singleWhere((element) => element.isToday);

  UnmodifiableListView<Streak> get streaks => UnmodifiableListView(_streaks);

  setAll(List<Streak> streaks) {
    _streaks = streaks;
    notifyListeners();
  }

  addAll(List<Streak> streaks) {
    _streaks.addAll(streaks);
    notifyListeners();
  }

  void updateOne(Streak streak) {
    final index = _streaks.indexWhere((element) => element.id == streak.id);

    _streaks[index] = streak;

    notifyListeners();
  }

  static Future<Paginate<Streak>> getStreak({String? nextURL, required Map<String, dynamic> query}) {
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
              Streak.fromJson,
            );
          default:
            return Future.error(response);
        }
      },
    );
  }

  static Future<Streak> updateStreak(int id, {required Map<String, dynamic> data}) {
    return patch(
      Uri.parse("$apiURL$id/"),
      body: jsonEncode(data),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then(
      (response) {
        switch (response.statusCode) {
          case HttpStatus.ok:
            return Streak.fromJson(jsonDecode(response.body));
          default:
            return Future.error(response);
        }
      },
    );
  }
}
