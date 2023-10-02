import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';

import '../../models/models.dart';
import '../controllers/controllers.dart';
import '../serializers/serializers.dart';
import '../serializers/serializers.dart' as serializer;
import 'components/custom_dismissible.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late final NotificationModel _notificationModel;

  @override
  void initState() {
    super.initState();

    _notificationModel = Provider.of<NotificationModel>(
      context,
      listen: false,
    );

    notificationController.listNotifications().then(
      (response) {
        _notificationModel.setAll(response.results);
        _notificationModel.loading = false;
      },
    ).catchError(
      (error, stackTrace) {
        log(
          "LOh error",
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  Widget getNotificationSmallIcon(serializer.Notification notification) {
    if (notification.icon != null) {
      return CircleAvatar(
        maxRadius: 12,
        child: Image.network(notification.icon!),
      );
    }

    if (notification.topic == NotificationTopic.streak) {
      return const CircleAvatar(
        child: Icon(CupertinoIcons.flame_fill),
      );
    }

    if (notification.topic == NotificationTopic.reward) {
      return const CircleAvatar(
        maxRadius: 16,
        child: Icon(
          CupertinoIcons.gift_fill,
          size: 16,
        ),
      );
    }

    if (notification.topic == NotificationTopic.comment) {
      return const CircleAvatar(
        maxRadius: 16,
        child: Icon(
          CupertinoIcons.chat_bubble_fill,
          size: 16,
        ),
      );
    }

    return const CircleAvatar(
      maxRadius: 16,
      child: Icon(
        Icons.notifications,
        size: 16,
      ),
    );
  }

  Widget _buildDismissBackground(Color color, Icon icon, CrossAxisAlignment crossAxisAlignment) {
    return Container(
      width: double.infinity,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon],
        ),
      ),
    );
  }

  Widget get _emptyState {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/illustrations/il_notifications_2.svg",
            width: 96.0,
            height: 96.0,
          ),
          const SizedBox(height: 24.0),
          const Text(
            "You don't have any notifications",
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          FilledButton(
            onPressed: () {},
            child: const Text("Explore courses"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Consumer<NotificationModel>(
        builder: (context, model, child) {
          final notifications = model.items;

          return notifications.isEmpty
              ? _emptyState
              : ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return CustomDismissible(
                      key: Key("${notification.id}"),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          final newNotification = await notificationController.updateNotification(
                            id: notification.id,
                            body: {"is_read": !notification.isRead},
                          );

                          _notificationModel.updateOne(newNotification);
                          return false;
                        }
                        if (direction == DismissDirection.endToStart) {
                          await notificationController.deleteNotification(id: notification.id);

                          _notificationModel.removeOne(notification);
                          return true;
                        }
                      },
                      getBackground: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          return _buildDismissBackground(
                            Colors.red,
                            const Icon(CupertinoIcons.delete),
                            CrossAxisAlignment.end,
                          );
                        }

                        return _buildDismissBackground(
                          Colors.deepPurpleAccent,
                          Icon(
                            notification.isRead ? Icons.check_circle_rounded : Icons.radio_button_unchecked_outlined,
                            size: 32,
                          ),
                          CrossAxisAlignment.start,
                        );
                      },
                      child: ListTile(
                        onTap: () async {
                          if (!notification.isRead) {
                            final newNotification = await notificationController.updateNotification(
                              id: notification.id,
                              body: {"is_read": true},
                            );

                            model.updateOne(newNotification);
                          }
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.network(
                            notification.image,
                            width: 48.0,
                            height: 48.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          notification.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Wrap(
                          runSpacing: 4.0,
                          children: [
                            Text(
                              notification.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Wrap(
                              spacing: 8.0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                getNotificationSmallIcon(notification),
                                Text(format(notification.createdAt)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
