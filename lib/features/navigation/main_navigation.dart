import 'package:flutter/material.dart';

import 'package:zuno/core/design/zuno_colors.dart';
import 'package:zuno/core/design/zuno_text.dart';

import 'package:zuno/features/feed/feed_screen.dart';
import 'package:zuno/features/feed/trending_screen.dart';
import 'package:zuno/features/community/community_screen.dart';
import 'package:zuno/features/notifications/notifications_screen.dart';
import 'package:zuno/features/profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FeedScreen(),                    // Home feed
    TrendingScreen(),                // Trending feed
    CommunityScreen(),               // Community
    NotificationsScreen(),           // Notifications
    ProfileScreen(userId: 'test-user-id'), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZunoColors.background,

      // ───────── App Bar ─────────
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ZunoColors.background,
        centerTitle: false,
        titleSpacing: 20,
        title: Text(
          "Zuno",
          style: ZunoText.logo(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 24),
            color: ZunoColors.textPrimary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: ZunoColors.border,
          ),
        ),
      ),

      // ───────── Active Screen ─────────
      body: _screens[_currentIndex],

      // ───────── Bottom Navigation ─────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ZunoColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: ZunoColors.surface,
          elevation: 0,
          selectedItemColor: ZunoColors.primary,
          unselectedItemColor: ZunoColors.textMuted,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, size: 26),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_outlined),
              activeIcon: Icon(Icons.trending_up, size: 26),
              label: 'Trending',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              activeIcon: Icon(Icons.play_circle, size: 26),
              label: 'Clips',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups, size: 26),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person, size: 26),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
