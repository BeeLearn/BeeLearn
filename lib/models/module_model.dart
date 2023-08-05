import 'dart:convert';
import 'dart:io';

import 'package:beelearn/main_application.dart';
import 'package:beelearn/serializers/lesson.dart';
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

  // Todo: Update this shitty code that work
  updateLessonOne({int? moduleId, required Lesson lesson}) {
    late final Module module;

    if (moduleId == null) {
      module = items.firstWhere((element) => element.lessons.contains(lesson));
    } else {
      Module? mModule = getEntityById(moduleId);

      if (mModule == null) return false;

      module = mModule;
    }

    final lessonIndex = module.lessons.indexWhere(
      (element) => element.id == lesson.id,
    );

    if (lessonIndex < 0) {
      return false;
    }

    module.lessons[lessonIndex] = lesson;

    return updateOne(module);
  }

  static Future<Paginate<Module>> getModules({Map<String, dynamic>? query, String? nextURL}) {
    return get(
      Uri.parse(nextURL ?? apiURL).replace(queryParameters: query),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}",
      },
    ).then((response) {
      return Paginate.fromJson(
        jsonDecode(response.body),
        Module.fromJson,
      );
    });
  }
}
