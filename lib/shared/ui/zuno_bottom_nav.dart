import 'package:flutter/material.dart';
import '../../core/design/zuno_colors.dart';


class ZunoBottomNav extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const ZunoBottomNav({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ZunoColors.surface,
      ),
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: onTap,
        backgroundColor: ZunoColors.surface,
        selectedItemColor: ZunoColors.primary,
        unselectedItemColor: ZunoColors.textMuted,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
