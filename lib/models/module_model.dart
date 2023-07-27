import 'dart:convert';
import 'dart:io';

import 'package:beelearn/main_application.dart';
import 'package:beelearn/serializers/module.dart';
import 'package:http/http.dart';

import '../serializers/paginate.dart';
import 'base_model.dart';

class ModuleModel extends BaseModel<Module> {
  static const apiURL = "${MainApplication.baseURL}/api/catalogue/modules/";

  @override
  int getEntityId(Module item) {
    return item.id;
  }

  @override
  int orderBy(Module first, Module second) {
    return first.id > second.id ? 1 : 0;
  }

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
