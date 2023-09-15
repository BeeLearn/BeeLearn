import '../mixins/api_model_mixin.dart';
import '../serializers/reply.dart';

class _ReplyController with ApiModelMixin {
  @override
  String get basePath => "api/messaging/replies";

  Future<Reply> createReply({
    Map<String, dynamic>? query,
    required Map<String, dynamic> body,
  }) {
    return super.create(
      query: query,
      body: body,
      fromJson: Reply.fromJson,
    );
  }
}

final replyController = _ReplyController();
