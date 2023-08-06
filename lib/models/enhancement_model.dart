import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../main_application.dart';
import '../serializers/enhancement.dart';
import '../serializers/paginate.dart';
import 'base_model.dart';

class EnhancementModel extends BaseModel<Enhancement> {
  static const apiURL = "${MainApplication.baseURL}/api/enhancement/enhancements/";
  @override
  int getEntityId(Enhancement item) => item.id;

  @override
  orderBy(Enhancement first, Enhancement second) => true ? 1 : -1;

  static Future<void> deleteEnhancement(int id) {
    return delete(Uri.parse("$apiURL$id/")).then((response) {
      switch (response.statusCode) {
        case HttpStatus.noContent:
          break;
        default:
          throw Error();
      }
    });
  }

  static Future<Paginate<Enhancement>> fetchEnhancements({Map<String, dynamic>? query}) {
    return get(
      Uri.parse(apiURL).replace(queryParameters: query),
      headers: {HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken}"},
    ).then((response) {
      switch (response.statusCode) {
        case HttpStatus.ok:
          return Paginate.fromJson(
            jsonDecode(response.body),
            Enhancement.fromJson,
          );
        default:
          throw Error();
      }
    });
  }
}
