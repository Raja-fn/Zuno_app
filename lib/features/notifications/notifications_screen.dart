import 'package:flutter/material.dart';
import '../../models/notification_data.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  List<NotificationData> _mockNotifications() {
    return [
      NotificationData(
        title: "New Like",
        message: "Someone liked your post",
        time: "2 min ago",
        icon: Icons.favorite,
      ),
      NotificationData(
        title: "New Comment",
        message: "Someone commented on your post",
        time: "10 min ago",
        icon: Icons.chat_bubble,
      ),
      NotificationData(
        title: "Trending",
        message: "Your post is trending 🔥",
        time: "1 hour ago",
        icon: Icons.trending_up,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _mockNotifications();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(n.icon, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        n.message,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  n.time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
