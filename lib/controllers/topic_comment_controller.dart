import 'package:beelearn/mixins/api_model_mixin.dart';

import '../serializers/paginate.dart';
import '../serializers/topic_comment.dart';

class _TopicCommentController with ApiModelMixin {
  @override
  String? get basePath => "api/catalogue/topic-comments";

  Future<Paginate<TopicComment>> getTopicComments({
    String? url,
    Map<String, dynamic>? query,
  }) {
    return list(
      url: url,
      query: query,
      fromJson: (json) => Paginate.fromJson(
        json,
        TopicComment.fromJson,
      ),
    );
  }

  Future<TopicComment> createTopicComment({
    Map<String, dynamic>? query,
    required Map<String, dynamic> body,
  }) {
    return create(
      body: body,
      query: query,
      fromJson: TopicComment.fromJson,
    );
  }

  Future<TopicComment> updateTopicComment({
    required int id,
    required Map<String, dynamic> body,
  }) {
    return update(
      path: id,
      body: body,
      fromJson: TopicComment.fromJson,
    );
  }
}

final topicCommentController = _TopicCommentController();
