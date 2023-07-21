import 'dart:convert';
import 'dart:io';

import 'package:beelearn/serializers/topic.dart';
import 'package:http/http.dart' show get, patch;

import '../../main_application.dart';
import '../serializers/paginate.dart';

class TopicModel {
  static const String apiURL = "${MainApplication.baseURL}/api/catalogue/topics/";

  static Future<Paginate<Topic>> getTopics({
    int? lessonId,
    String? nextURL,
  }) {
    final url = nextURL ?? "$apiURL?lesson=$lessonId";

    return get(
      Uri.parse(url),
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
        HttpHeaders.authorizationHeader: "Token ${MainApplication.testAccessToken}",
      },
      body: data,
    ).then((response) {
      return Topic.fromJson(jsonDecode(response.body));
    });
  }
}
