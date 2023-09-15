import '../serializers/comment.dart';
import '../serializers/reply.dart';
import '../serializers/thread.dart';
import 'base_model.dart';

class ThreadModel extends BaseModel<Comment> {
  @override
  int getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => first.createdAt.compareTo(second.createdAt);

  void setThreads(List<Thread> threads) {
    setAll(
      threads.map((thread) => thread.comment).toList(),
    );
  }

  void addThreads(List<Thread> threads) {
    addAll(
      threads.map((thread) => thread.comment).toList(),
    );
  }

  void addThread(Thread thread) => setOne(thread.comment);
  void updateThread(Thread thread) => updateOne(thread.comment);
  void removeThread(Thread thread) => removeOne(thread.comment);

  /// add new reply to parent comment
  /// comment.replies is a set
  void setReply(Reply reply) {
    final Comment? parentComment = getEntityById(reply.parent);
    parentComment?.replies?.add(reply.comment);
    if (parentComment != null) setOne(parentComment);
  }

  /// update comment.replies by deleting previous existing in set
  void updateReply(Reply reply) {
    // don't use nonnull here, websocket updates are unpredictable
    final Comment? parentComment = getEntityById(reply.parent);
    parentComment?.replies?.remove(reply.comment);
    parentComment?.replies?.add(reply.comment);
    if (parentComment != null) setOne(parentComment);
  }

  removeReply(Reply reply) {
    final Comment? parentComment = getEntityById(reply.parent);
    parentComment?.replies?.remove(reply.comment);
    if (parentComment != null) setOne(parentComment);
  }
}
