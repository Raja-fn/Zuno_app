import 'package:flutter/material.dart';
import 'package:zuno/services/notification_service.dart';
import 'package:zuno/services/chat_service.dart';
import 'package:zuno/features/chat/chat_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _service = NotificationService();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchNotifications();
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'follow':
        return Icons.person_add;
      case 'comment':
        return Icons.chat_bubble;
      case 'message':
        return Icons.chat;
      default:
        return Icons.notifications;
    }
  }

  String _titleForType(String type) {
    switch (type) {
      case 'like':
        return "New Like";
      case 'follow':
        return "New Follower";
      case 'comment':
        return "New Comment";
      case 'message':
        return "New Message";
      default:
        return "Notification";
    }
  }

  String _messageForType(String type, String actor) {
    switch (type) {
      case 'like':
        return "$actor liked your post";
      case 'follow':
        return "$actor started following you";
      case 'comment':
        return "$actor commented on your post";
      case 'message':
        return "$actor sent you a message";
      default:
        return "You have a new notification";
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(child: Text(snap.error.toString()));
          }

          final notifications = snap.data ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text("No notifications yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];

              final actor = n['actor']?['email']
                  ?.split('@')
                  .first ??
                  'Someone';

              final senderId = n['actor_id'];

              return GestureDetector(
                onTap: () async {
                  await _service.markAsRead(n['id']);

                  if (n['type'] == 'message' && senderId != null) {
                    final chatId = await ChatService().getOrCreateChat(
                      otherUserId: senderId, currentUserId: '',
                    );

                    if (!mounted) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          chatId: chatId,
                          otherUserId: senderId,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                    n['is_read'] ? Colors.white : Colors.blue.shade50,
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
                        child: Icon(
                          _iconForType(n['type']),
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _titleForType(n['type']),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _messageForType(n['type'], actor),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _timeAgo(n['created_at']),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
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

  String _timeAgo(String iso) {
    final time = DateTime.parse(iso);
    final diff = DateTime.now().difference(time);

    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    return "${diff.inDays} day ago";
  }
}
