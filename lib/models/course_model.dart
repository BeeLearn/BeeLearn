import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show get, patch;

import '../../main_application.dart';
import '../serializers/course.dart';
import '../serializers/paginate.dart';
import 'base_model.dart';

class CourseModel extends BaseModel<Course> {
  static const String apiURL = "${MainApplication.baseURL}/api/catalogue/courses/";

  @override
  int getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => first.id > second.id ? 1 : 0;

  static Future<Paginate<Course>> getCourses({Map<String, dynamic>? query, String? nextURL}) {
    Uri uri = Uri.parse(nextURL ?? apiURL).replace(queryParameters: query);
    return get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then((response) {
      return Paginate.fromJson(
        jsonDecode(response.body),
        Course.fromJson,
      );
    });
  }

  static Future<Course> updateCourse({required int id, required Map<String, dynamic> data}) {
    return patch(
      Uri.parse("$apiURL$id/"),
      body: jsonEncode(data),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then((response) {
      switch (response.statusCode) {
        case HttpStatus.ok:
          return Course.fromJson(jsonDecode(response.body));
        default:
          print(response.body);
          throw Error();
      }
    });
  }
}

class NewCourseModel extends CourseModel {}

class InProgressCourseModel extends CourseModel {}

class CompletedCourseModel extends CourseModel {}

class FavouriteCourseModel extends CourseModel {}
