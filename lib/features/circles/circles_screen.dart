import 'package:flutter/material.dart';
import '../../core/theme/zuno_colors.dart';
import '../community/community_feed_screen.dart';

class CirclesScreen extends StatelessWidget {
  const CirclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 📍 CITY CIRCLE
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CommunityFeedScreen(
                      title: "Jaipur City",
                      community: "city",
                    ),
                  ),
                );
              },
              child: _circleTile("📍 Jaipur City"),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CommunityFeedScreen(
                      title: "College Circle",
                      community: "college",
                    ),
                  ),
                );
              },
              child: _circleTile("🎓 College Circle"),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CommunityFeedScreen(
                      title: "Festival Circle",
                      community: "festival",
                    ),
                  ),
                );
              },
              child: _circleTile("🎉 Festival Circle"),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Reusable Circle UI
  Widget _circleTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ZunoColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: ZunoColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: ZunoColors.textMuted,
            size: 16,
          ),
        ],
      ),
    );
  }
}
