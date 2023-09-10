import '../mixins/api_model_mixin.dart';
import '../serializers/user.dart';

/// Todo switch path to services, This should be _UserService
class _UserController with ApiModelMixin {
  @override
  String get basePath => "api/account/users";
  String get currentUserApiPath => "current-user";

  Future<User> getCurrentUser() {
    return list(
      url: getDetailedPath(currentUserApiPath),
      fromJson: User.fromJson,
    );
  }

  Future<User> updateUser({
    required int id,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? body,
  }) {
    return super.update(
      id: id,
      query: query,
      body: body,
      fromJson: User.fromJson,
    );
  }
}

/// Todo this should be userService
final userController = _UserController();
