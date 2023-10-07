import '../models/base_model.dart';
import '../serializers/notification.dart';

class NotificationModel extends BaseModel<Notification> {
  String? _next;

  String? get next => _next;
  set next(String? value) {
    _next = value;
    notifyListeners();
  }

  @override
  int getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => second.createdAt.compareTo(first.createdAt);
}
