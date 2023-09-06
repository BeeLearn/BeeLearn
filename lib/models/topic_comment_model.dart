import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../main_application.dart';
import '../serializers/paginate.dart';
import '../serializers/topic_comment.dart';
import 'base_model.dart';

class TopicCommentModel extends BaseModel<TopicComment> {
  String apiUrl = "${MainApplication.baseURL}/api/catalogue/topic-comments/";

  @override
  int getEntityId(TopicComment item) => item.id;

  @override
  int orderBy(first, second) => second.createdAt.compareTo(first.createdAt);

  // Future<void> updateSubComment(TopicComment subTopicComment) async {
  //   final parentTopicComment = getEntityById(subTopicComment.parentId);
  //   log(jsonEncode(parentTopicComment?.toJson()));
  //
  //   if (parentTopicComment != null) {
  //     final subParentTopicIndex = parentTopicComment.subTopicComments?.indexOf(subTopicComment);
  //     if (subParentTopicIndex != null) {
  //       parentTopicComment.subTopicComments![subParentTopicIndex] = subTopicComment;
  //     } else {
  //       parentTopicComment.subTopicComments?.add(subTopicComment);
  //     }
  //
  //     updateOne(parentTopicComment);
  //   }
  // }

  Future<Paginate<TopicComment>> getTopicComments({String? url, Map<String, dynamic>? query}) {
    return get(
      Uri.parse(url ?? apiUrl).replace(queryParameters: query),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then(
      (response) {
        switch (response.statusCode) {
          case HttpStatus.ok:
            return Paginate.fromJson(
              jsonDecode(response.body),
              TopicComment.fromJson,
            );
          default:
            return Future.error(response);
        }
      },
    );
  }

  Future<TopicComment> createTopicComment({required Map<String, dynamic> data}) {
    return post(
      Uri.parse(apiUrl),
      body: jsonEncode(data),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then(
      (response) {
        switch (response.statusCode) {
          case HttpStatus.created:
            return TopicComment.fromJson(
              jsonDecode(response.body),
            );
          default:
            return Future.error(response);
        }
      },
    );
  }

  Future<TopicComment> updateTopicComment({
    required int id,
    required Map<String, dynamic> data,
  }) {
    return patch(
      Uri.parse("$apiUrl$id/"),
      body: jsonEncode(data),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then(
      (response) {
        switch (response.statusCode) {
          case HttpStatus.ok:
            return TopicComment.fromJson(
              jsonDecode(response.body),
            );
          default:
            return Future.error(response);
        }
      },
    );
  }
}
