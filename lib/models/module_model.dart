import 'dart:convert';
import 'dart:io';

import 'package:beelearn/main_application.dart';
import 'package:beelearn/serializers/module.dart';
import 'package:http/http.dart';

import '../serializers/paginate.dart';

class ModuleModel {
  static const apiURL = "${MainApplication.baseURL}/api/catalogue/modules/";

  static Future<Paginate<Module>> getModules({int? courseId, String? nextURL}) {
    final url = nextURL ?? "$apiURL?courseId=$courseId";
    return get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.testAccessToken}",
      },
    ).then((response) {
      return Paginate.fromJson(
        jsonDecode(response.body),
        Module.fromJson,
      );
    });
  }
}
