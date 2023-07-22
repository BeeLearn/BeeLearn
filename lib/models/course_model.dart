import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show get, patch;

import '../../main_application.dart';
import '../serializers/course.dart';
import '../serializers/paginate.dart';

class CourseModel<T> extends ChangeNotifier {
  List<T> _courses = [];
  UnmodifiableListView<T> get courses => UnmodifiableListView(_courses);

  static const String apiURL = "${MainApplication.baseURL}/api/catalogue/courses/";

  setAll(List<T> courses) {
    _courses = courses;
    notifyListeners();
  }

  addAll(List<T> courses) {
    _courses.addAll(courses);
    notifyListeners();
  }

  updateOne(int index, T course) {
    _courses[index] = course;
    notifyListeners();
  }

  static getCourses({Map<String, dynamic>? query, String? nextURL}) {
    Uri uri = Uri.parse(nextURL ?? apiURL).replace(queryParameters: query);
    return get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.testAccessToken}",
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
        HttpHeaders.authorizationHeader: "Token ${MainApplication.testAccessToken}",
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
