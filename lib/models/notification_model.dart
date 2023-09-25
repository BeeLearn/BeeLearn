import '../models/base_model.dart';
import '../serializers/notification.dart';

class NotificationModel extends BaseModel<Notification> {
  @override
  int getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => first.createdAt.compareTo(second.createdAt);
}
