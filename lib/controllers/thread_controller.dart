import 'package:beelearn/serializers/paginate.dart';
import 'package:beelearn/serializers/thread.dart';

import '../mixins/api_model_mixin.dart';

class _ThreadController with ApiModelMixin {
  @override
  String? get basePath => "api/messaging/threads";

  /// Get thread comments, returns parent comments for query.
  /// [query].reference thread owner thread_reference
  Future<Paginate<Thread>> getThreads({
    String? url,
    Map<String, dynamic>? query,
  }) {
    return list(
      url: url,
      query: query,
      fromJson: (json) => Paginate.fromJson(json, Thread.fromJson),
    );
  }

  /// Create sub comment in a thread called parent comments
  /// [body].comment json of map [Comment]
  createThread({required Map<String, dynamic> body}) {
    return create(
      body: body,
      fromJson: Thread.fromJson,
    );
  }
}

final threadController = _ThreadController();
