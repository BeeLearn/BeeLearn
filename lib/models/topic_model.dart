import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' show get, patch;

import '../../main_application.dart';
import '../serializers/paginate.dart';
import '../serializers/topic.dart';

class TopicModel extends ChangeNotifier {
  List<Topic> _topics = [];
  static const String apiURL = "${MainApplication.baseURL}/api/catalogue/topics/";

  UnmodifiableListView<Topic> get topics => UnmodifiableListView(_topics);

  setAll(List<Topic> topics) {
    _topics = topics;
    notifyListeners();
  }

  addAll(List<Topic> topics) {
    _topics.addAll(topics);
    notifyListeners();
  }

  updateOne(int index, Topic topic) {
    _topics[index] = topic;
    notifyListeners();
  }

  static Future<Paginate<Topic>> getTopics({
    Map<String, dynamic>? query,
    String? nextURL,
  }) {
    return get(
      Uri.parse(nextURL ?? apiURL).replace(queryParameters: query),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.testAccessToken}",
      },
    ).then((response) {
      return Paginate.fromJson(
        jsonDecode(response.body),
        Topic.fromJson,
      );
    });
  }

  static Future<Topic> updateTopic({
    required int id,
    required Map<String, dynamic> data,
  }) {
    return patch(
      Uri.parse("$apiURL$id/"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Token ${MainApplication.testAccessToken}",
      },
      body: jsonEncode(data),
    ).then((response) {
      switch (response.statusCode) {
        case HttpStatus.ok:
          return Topic.fromJson(jsonDecode(response.body));
        default:
          print(response.body);
          throw Error();
      }
    });
  }
}
