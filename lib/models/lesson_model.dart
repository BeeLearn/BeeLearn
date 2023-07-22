import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show get;

import '../../main_application.dart';
import '../serializers/lesson.dart';
import '../serializers/paginate.dart';

/// [LessonModel] provide [Lesson] API logic
class LessonModel {
  static const String apiURL = "${MainApplication.baseURL}/api/catalogue/lessons/";

  /// [getLessons] return filtered lesson for a particular course
  /// [courseId] required if [nextURL] is not provided
  /// [nextURL] required is [courseId] is not provided
  static Future<Paginate<Lesson>> getLessons({
    int? courseId,
    String? nextURL,
  }) {
    if (nextURL == null && courseId == null) {
      throw Exception("Either nextURL or courseId is required");
    }

    final url = nextURL ?? "$apiURL?course=$courseId";

    return get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.testAccessToken}",
      },
    ).then((response) {
      return Paginate.fromJson(
        jsonDecode(response.body),
        Lesson.fromJson,
      );
    });
  }
}
