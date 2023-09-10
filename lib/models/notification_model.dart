import '../mixins/api_model_mixin.dart';
import '../models/base_model.dart';
import '../serializers/notification.dart';
import '../serializers/paginate.dart';

class NotificationModel extends BaseModel<Notification> with ApiModelMixin {
  @override
  int getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => first.createdAt.compareTo(second.createdAt);

  @override
  String? get basePath => "api/account/notifications";

  Future<Paginate<Notification>> listNotifications<T>({
    String? url,
    Map<String, dynamic>? query,
  }) {
    return list(
      url: url,
      fromJson: (json) => Paginate.fromJson(json, Notification.fromJson),
    );
  }

  Future<Notification> updateNotification({
    required int id,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? body,
  }) {
    return super.update(
      id: id,
      query: query,
      body: body,
      fromJson: Notification.fromJson,
    );
  }
}
