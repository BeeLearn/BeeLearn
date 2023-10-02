import '../models/base_model.dart';
import '../serializers/notification.dart';

class NotificationModel extends BaseModel<Notification> {
  int? _unread;

  int get unread => _unread ?? 0;

  set unread(int value) {
    _unread = unread;
    notifyListeners();
  }

  @override
  int getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => first.createdAt.compareTo(second.createdAt);
}
