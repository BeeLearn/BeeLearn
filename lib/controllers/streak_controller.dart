import '../mixins/api_model_mixin.dart';
import '../serializers/serializers.dart';

class _StreakController with ApiModelMixin {
  @override
  String get basePath => "api/reward/streaks";

  Future<Paginate<Streak>> getPaginatedStreaks({
    String? nextURL,
    required Map<String, dynamic> query,
  }) {
    return list(
      query: query,
      url: nextURL,
      fromJson: (Map<String, dynamic> json) => Paginate.fromJson(
        json,
        Streak.fromJson,
      ),
    );
  }

  Future<List<Streak>> getStreaks({
    String? nextURL,
    required Map<String, dynamic> query,
  }) {
    return list(
      query: query,
      url: nextURL,
      fromJson: (List<dynamic> json) => json.map((json) => Streak.fromJson(json)).toList(),
    );
  }

  Future<Streak> updateStreak({
    required int id,
    required Map<String, dynamic> body,
  }) {
    return update(
      path: id,
      body: body,
      fromJson: Streak.fromJson,
    );
  }
}

final streakController = _StreakController();
