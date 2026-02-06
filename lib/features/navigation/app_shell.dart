import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../feed/feed_screen.dart';
import '../search/user_search_screen.dart';
import '../community/community_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../post/post_compose_screen.dart';
import 'jaipur_updates_banner.dart';
import 'package:zuno/config/api_config.dart';
import '../chat/chat_list_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0; // 0: Home, 1: Search, 2: Community, 3: Chat
  String? _currentUserId;
  int _unreadNotifications = 3;

  @override
  void initState() {
    super.initState();
    _currentUserId = Supabase.instance.client.auth.currentUser?.id;
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            if (_currentUserId != null) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
            }
          },
        ),
        if (_unreadNotifications > 0)
          Positioned(right: 8, top: 6, child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text('$_unreadNotifications', style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
          )),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return IconButton(
      icon: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
      onPressed: () {
        if (_currentUserId != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: _currentUserId!)));
        }
      },
    );
  }

  Widget _screenForIndex(int index) {
    switch (index) {
      case 0:
        return Column(children: [JaipurUpdatesBanner(), Expanded(child: FeedScreen())]);
      case 1:
        return UserSearchScreen();
      case 2:
        return CommunityScreen();
      case 3:
        return ChatListScreen();
      default:
        return FeedScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZUNO'),
        actions: [_buildNotificationButton(), _buildProfileAvatar()],
      ),
      body: _screenForIndex(_currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostComposeScreen())),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black54),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(height: 60, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () => setState(() => _currentIndex = 0)),
            IconButton(icon: const Icon(Icons.search), onPressed: () => setState(() => _currentIndex = 1)),
          ]),
          Row(children: [
            IconButton(icon: const Icon(Icons.people), onPressed: () => setState(() => _currentIndex = 2)),
            IconButton(icon: const Icon(Icons.chat), onPressed: () => setState(() => _currentIndex = 3)),
          ]),
        ])),
      ),
    );
  }
}
