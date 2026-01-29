import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key}); // 👈 THIS must be const

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.home),
            Icon(Icons.search),
            SizedBox(width: 40),
            Icon(Icons.favorite_border),
            Icon(Icons.person_outline),
          ],
        ),
      ),
    );
  }
}
