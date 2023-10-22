import 'dart:collection';

import 'package:beelearn/views/components/loadmore_widget.dart';
import 'package:beelearn/views/fragments/dialog_fragment.dart';
import 'package:beelearn/widget_keys.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loadmore/loadmore.dart';
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
  }

  Widget _getNotificationSmallIcon(serializer.Notification notification) {
    if (notification.icon != null) {
      return CircleAvatar(
        maxRadius: 12,
        child: CachedNetworkImage(imageUrl: notification.icon!),
      );
    }

    if (notification.topic == NotificationTopic.streak) {
      return const CircleAvatar(
        maxRadius: 16,
        child: Icon(
          CupertinoIcons.flame_fill,
          size: 16,
        ),
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
            "You don't have any notifications!",
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          FilledButton.icon(
            onPressed: _loadNotifications,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Refresh"),
          ),
        ],
      ),
    );
  }

  Future<void> _loadNotifications({String? url}) async {
    final response = await notificationController.listNotifications(url: url);
    _notificationModel.next = response.next;
    if (url == null) {
      _notificationModel.setAll(response.results);
    } else {
      _notificationModel.addAll(response.results);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogFragment(
      alignment: Alignment.topRight,
      insetPadding: EdgeInsets.zero,
      builder: (context) => Scaffold(
        appBar: AppBar(
          leading: const CloseButton(key: notificationModalDismissButtonKey),
          title: const Text("Notifications"),
        ),
        body: Selector<NotificationModel, UnmodifiableListView<serializer.Notification>>(
          selector: (context, model) => model.items,
          builder: (context, notifications, child) {
            return _notificationModel.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : notifications.isEmpty
                    ? _emptyState
                    : RefreshIndicator(
                        onRefresh: _loadNotifications,
                        child: LoadMore(
                          isFinish: _notificationModel.next == null,
                          onLoadMore: () async {
                            if (_notificationModel.next == null) return false;
                            await _loadNotifications(url: _notificationModel.next);

                            return true;
                          },
                          delegate: const CustomLoadMoreDelegate(),
                          child: ListView.separated(
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
                                      body: {
                                        "is_read": !notification.isRead,
                                      },
                                    );

                                    _notificationModel.updateOne(newNotification);
                                    return false;
                                  }

                                  if (direction == DismissDirection.endToStart) {
                                    await notificationController.deleteNotification(id: notification.id);

                                    _notificationModel.removeOne(notification);
                                    return true;
                                  }

                                  return null;
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
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: CachedNetworkImage(
                                      imageUrl: notification.image,
                                      width: 48.0,
                                      height: 48.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    notification.title,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              notification.body,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Wrap(
                                        spacing: 8.0,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          _getNotificationSmallIcon(notification),
                                          Text(format(notification.createdAt)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
          },
        ),
      ),
    );
  }
}
