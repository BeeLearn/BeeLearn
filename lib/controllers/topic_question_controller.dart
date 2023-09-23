import 'package:beelearn/serializers/serializers.dart';

import '../mixins/api_model_mixin.dart';

class _TopicQuestionController with ApiModelMixin {
  @override
  String get basePath => "api/catalogue/topic-questions";

  Future<TopicQuestion> updateTopicQuestion({
    required id,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? body,
  }) {
    return super.update(
      path: id,
      query: query,
      body: body,
      fromJson: TopicQuestion.fromJson,
    );
  }
}

final topicQuestionController = _TopicQuestionController();
