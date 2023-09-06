import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:beelearn/serializers/course.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:http/http.dart' show get;

import '../../main_application.dart';
import '../serializers/category.dart';
import '../serializers/paginate.dart';

class CategoryModel extends ChangeNotifier {
  static const String apiURL = "${MainApplication.baseURL}/api/catalogue/categories/";

  bool _loading = true;

  bool get loading => _loading;

  set loading(value) {
    _loading = value;
    notifyListeners();
  }

  List<Category> _categories = [];

  UnmodifiableListView<Category> get categories => UnmodifiableListView(_categories);

  void setAll(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  void addAll(List<Category> categories) {
    _categories.addAll(categories);
    notifyListeners();
  }

  void updateCourse({
    required int categoryIndex,
    required int courseIndex,
    required Course course,
  }) {
    _categories[categoryIndex].courses[courseIndex] = course;
    notifyListeners();
  }

  static Future<Paginate<Category>> getCategories({String next = apiURL}) {
    return get(
      Uri.parse(next),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then(
      (response) {
        switch (response.statusCode) {
          case HttpStatus.ok:
            return Paginate.fromJson(
              jsonDecode(response.body),
              Category.fromJson,
            );
          default:
            return Future.error(response);
        }
      },
    );
  }
}
