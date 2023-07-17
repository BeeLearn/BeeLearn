import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show get;

import '../../main_application.dart';
import '../serializers/course.dart';
import '../serializers/paginate.dart';
import '../serializers/user_course.dart';

class BaseModel<T> extends ChangeNotifier {
  List<T> _courses = [];
  UnmodifiableListView<T> get courses => UnmodifiableListView(_courses);

  setAll(List<T> courses) {
    _courses = courses;
    notifyListeners();
  }

  addAll(List<T> courses) {
    _courses.addAll(courses);
    notifyListeners();
  }

  static getCourses(
    converter,
    apiURL, {
    Map<String, dynamic>? query,
    String? nextURL,
  }) {
    Uri uri = Uri.parse(nextURL ?? apiURL).replace(queryParameters: query);
    return get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Token 55b3dcf6b57c5b8b2bf88e094a86221c167bf76f",
      },
    ).then((response) {
      return Paginate.fromJson(
        jsonDecode(response.body),
        converter,
      );
    });
  }
}

class CourseModel extends BaseModel {
  static const String apiURL = "${MainApplication.baseURL}/api/catalogue/courses/";

  static getCourses({required Map<String, dynamic> query, String? nextURL}) {
    return BaseModel.getCourses(
      Course.fromJson,
      apiURL,
      query: query,
      nextURL: nextURL,
    );
  }
}

class UserCourseBaseModel extends BaseModel {
  static const String apiURL = "${MainApplication.baseURL}/api/account/courses/";

  static getCourses({required Map<String, dynamic> query, String? nextURL}) {
    return BaseModel.getCourses(
      UserCourse.fromJson,
      apiURL,
      query: query,
      nextURL: nextURL,
    );
  }
}

class NewCourseModel extends CourseModel {}

class InProgressCourseModel extends UserCourseBaseModel {}

class CompletedCourseModel extends UserCourseBaseModel {}
