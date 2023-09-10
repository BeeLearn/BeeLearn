import '../mixins/api_model_mixin.dart';
import '../serializers/settings.dart';

class _SettingsController with ApiModelMixin {
  @override
  String get basePath => "api/account/settings";

  Future<Settings> updateSettings({
    required int id,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? body,
  }) {
    return update(
      path: id,
      body: body,
      query: query,
      fromJson: Settings.fromJson,
    );
  }
}
