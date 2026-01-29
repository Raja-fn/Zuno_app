import 'package:flutter/material.dart';

import 'package:zuno/core/design/zuno_spacing.dart';
import 'package:zuno/core/design/zuno_text.dart';
import 'package:zuno/services/comment_service.dart';
import 'package:zuno/features/comments/models/comment_model.dart';
import 'package:zuno/features/comments/widgets/comment_tile.dart';

class CommentsList extends StatelessWidget {
  final String postId;

  const CommentsList({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommentModel>>(
      future: CommentService().fetchComments(postId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final List<CommentModel> comments = snapshot.data!;
        if (comments.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: comments.map((c) => CommentTile(comment: c)).toList(),
        );
      },
    );
  }
}
