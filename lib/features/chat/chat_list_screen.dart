import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  SupabaseClient get _supabase => Supabase.instance.client;
  String? get currentUserId => _supabase.auth.currentUser?.id;

  @override
  Widget build(BuildContext context) {
    final uid = currentUserId;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text("Session expired. Please login again.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _supabase
            .from('direct_message_threads')
            .stream(primaryKey: ['id'])
            .order('updated_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }

          // 🔥 Filter chats for current user (done in Dart)
          final threads = snapshot.data!
              .where(
                (t) => t['user1'] == uid || t['user2'] == uid,
          )
              .toList();

          if (threads.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          return ListView.builder(
            itemCount: threads.length,
            itemBuilder: (context, index) {
              return _ChatTile(
                thread: threads[index],
                currentUserId: uid,
              );
            },
          );
        },
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final Map<String, dynamic> thread;
  final String currentUserId;

  const _ChatTile({
    required this.thread,
    required this.currentUserId,
  });

  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final otherUserId =
    thread['user1'] == currentUserId ? thread['user2'] : thread['user1'];

    return FutureBuilder<_ChatTileData>(
      future: _loadTileData(otherUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ListTile(title: Text("Loading..."));
        }

        final data = snapshot.data!;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
            data.avatarUrl != null ? NetworkImage(data.avatarUrl!) : null,
            child: data.avatarUrl == null
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(
            data.username,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            data.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            data.time,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  chatId: thread['id'],
                  otherUserId: otherUserId,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<_ChatTileData> _loadTileData(String otherUserId) async {
    // 1️⃣ Fetch user profile
    final profile = await _supabase
        .from('profiles')
        .select('username, avatar_url')
        .eq('id', otherUserId)
        .single();

    // 2️⃣ Fetch last message
    final lastMsg = await _supabase
        .from('messages')
        .select('content, created_at')
        .eq('chat_id', thread['id'])
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return _ChatTileData(
      username: profile['username'],
      avatarUrl: profile['avatar_url'],
      lastMessage: lastMsg?['content'] ?? 'Say hi 👋',
      time: lastMsg != null ? _formatTime(lastMsg['created_at']) : '',
    );
  }

  String _formatTime(String iso) {
    final dt = DateTime.parse(iso);
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}

// ─────────────────────────
// DATA MODEL (CLEAN & SAFE)
// ─────────────────────────
class _ChatTileData {
  final String username;
  final String? avatarUrl;
  final String lastMessage;
  final String time;

  _ChatTileData({
    required this.username,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
  });
}
