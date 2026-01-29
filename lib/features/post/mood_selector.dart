import 'package:flutter/material.dart';
import '../../core/theme/zuno_colors.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = ["😄 Chill", "🔥 Hype", "😔 Low", "💭 Thinking"];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: moods
            .map(
              (mood) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              decoration: BoxDecoration(
                color: ZunoColors.background,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  mood,
                  style: const TextStyle(
                    color: ZunoColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}

