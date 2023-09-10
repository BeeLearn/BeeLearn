import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/notification_model.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Consumer<NotificationModel>(
        builder: (context, model, child) {
          final notifications = model.items;

          return ListView.builder(
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                onTap: () async {
                  if (notification.intentTo != null) context.go(notification.intentTo!);

                  if (!notification.isRead) {
                    final newNotification = await model.updateNotification(
                      id: notification.id,
                      body: {
                        "is_read": true,
                      },
                    );

                    model.updateOne(newNotification);
                  }
                },
                leading: notification.smallImage == null
                    ? null
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          notification.smallImage!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                title: Text(notification.content),
              );
            },
          );
        },
      ),
    );
  }
}
