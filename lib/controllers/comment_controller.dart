import 'package:flutter/widgets.dart';

import '../mixins/api_model_mixin.dart';
import '../serializers/comment.dart';

@immutable
class _CommentController with ApiModelMixin {
  @override
  String get basePath => "api/messaging/comments";

  /// Retrieve a comment
  Future<Comment> getComment<T>({
    required int id,
    Map<String, dynamic>? query,
  }) {
    return super.retrieve(
      id: id,
      query: query,
      fromJson: Comment.fromJson,
    );
  }

  /// Update a comment
  /// [body] is typeof Partial[Comment]
  Future<Comment> updateComment<T>({
    required int id,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? body,
  }) {
    return super.update(
      path: id,
      query: query,
      body: body,
      fromJson: Comment.fromJson,
    );
  }

  /// delete a comment
  Future<Comment> deleteComment<T>({
    required int id,
    Map<String, dynamic>? query,
  }) {
    return super.update(
      path: id,
      query: query,
      body: {"is_deleted": true},
      fromJson: Comment.fromJson,
    );
  }
}

final commentController = _CommentController();
