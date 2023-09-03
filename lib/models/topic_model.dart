import 'dart:convert';
import 'dart:io';

import 'package:beelearn/models/base_model.dart';
import 'package:http/http.dart' show get, patch, post;

import '../../main_application.dart';
import '../serializers/enhancement.dart';
import '../serializers/paginate.dart';
import '../serializers/topic.dart';

// Todo Fix Bug When Extending BaseModel
class TopicModel extends BaseModel<Topic> {
  static const String apiURL = "${MainApplication.baseURL}/api/catalogue/topics/";

  @override
  int getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => first.createdAt.compareTo(second.createdAt);

  setEnhancement(int index, Enhancement? enhancement) {
    final topic = items[index];
    topic.enhancement = enhancement;
    return updateOne(topic);
  }

  static Future<Paginate<Topic>> getTopics({
    Map<String, dynamic>? query,
    String? nextURL,
  }) {
    return get(
      Uri.parse(nextURL ?? apiURL).replace(queryParameters: query),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
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
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
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

  static Future<Enhancement> enhanceTopic({
    int? id,
    String? nextURL,
    required EnhancementType type,
  }) {
    final path = type == EnhancementType.enhance ? "enhance" : "summarize";

    return post(
      Uri.parse(nextURL ?? "$apiURL$id/$path/"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then(
      (response) {
        switch (response.statusCode) {
          case HttpStatus.created:
            return Enhancement.fromJson(jsonDecode(response.body));
          default:
            throw Error();
        }
      },
    );
  }
}
