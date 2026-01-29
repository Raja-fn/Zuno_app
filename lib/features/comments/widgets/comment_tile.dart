import 'package:flutter/material.dart';
import '../../../core/design/zuno_colors.dart';
import '../../../core/design/zuno_text.dart';
import '../models/comment_model.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  const CommentTile({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 16, backgroundColor: ZunoColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.postId, style: ZunoText.body()),
                Text(comment.content, style: ZunoText.caption()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
