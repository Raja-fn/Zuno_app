import 'package:flutter/material.dart';
import '../../../core/design/zuno_text.dart';
import '../../../core/design/zuno_spacing.dart';
import '../models/comment_data.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ZunoSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
          SizedBox(width: ZunoSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment.username, style: ZunoText.body()),
                    SizedBox(width: ZunoSpacing.sm),
                    Text(comment.timeAgo, style: ZunoText.caption()),
                  ],
                ),
                SizedBox(height: 4),
                Text(comment.content, style: ZunoText.body()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
