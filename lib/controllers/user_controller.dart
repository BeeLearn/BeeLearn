import 'dart:developer';

import 'package:http/http.dart';

import '../mixins/api_model_mixin.dart';
import '../serializers/user.dart';

/// Todo switch path to services, This should be _UserService
class _UserController with ApiModelMixin {
  @override
  String get basePath => "api/account/users";
  String get currentUserApiPath => "current-user";

  Future<User> getCurrentUser() {
    log("headers", error: headers);
    return list(
      url: getDetailedPath(currentUserApiPath),
      fromJson: User.fromJson,
    );
  }

  Future<User> updateCurrentUser({required Map<String, dynamic> body}) {
    return update(
      body: body,
      fromJson: User.fromJson,
      path: currentUserApiPath,
    );
  }

  Future<User> updateUser({
    required int id,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? body,
  }) {
    return super.update(
      path: id,
      query: query,
      body: body,
      fromJson: User.fromJson,
    );
  }

  Future<User> updateMultipartUser({
    List<MultipartFile>? multipartFiles,
    required int id,
    Map<String, String>? fields,
  }) {
    return super.multipartRequest(
      id: id,
      method: "PATCH",
      fields: fields,
      multipartFiles: multipartFiles,
      fromJson: User.fromJson,
    );
  }
}

/// Todo this should be userService
final userController = _UserController();
