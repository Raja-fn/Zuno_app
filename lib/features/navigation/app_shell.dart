import 'package:flutter/material.dart';

import '../feed/feed_screen.dart';
import '../feed/trending_screen.dart';
import '../community/community_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import 'bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  /// ✅ SCREENS LIST (ORDER MATTERS)
  final List<Widget> _screens = const [
    FeedScreen(),           // 0
    TrendingScreen(),       // 1
    CommunityScreen(),      // 2
    NotificationsScreen(),  // 3
    ProfileScreen(userId: 'test-user-id'), // 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // ✅ FIXED
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
