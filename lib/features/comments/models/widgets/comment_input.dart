import 'package:flutter/material.dart';

import '../../../core/design/zuno_spacing.dart';
import '../../../core/design/zuno_text.dart';
import '../../../services/comment_service.dart';

class CommentInput extends StatefulWidget {
  final String postId;
  final VoidCallback onCommentAdded;

  const CommentInput({
    super.key,
    required this.postId,
    required this.onCommentAdded,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _loading = true);

    try {
      await CommentService().addComment(
        postId: widget.postId,
        content: text,
      );

      _controller.clear();
      widget.onCommentAdded();
    } catch (e) {
      debugPrint("COMMENT ERROR: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: ZunoSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Add a comment...",
                border: InputBorder.none,
              ),
              style: ZunoText.caption(),
            ),
          ),
          _loading
              ? const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : IconButton(
            icon: const Icon(Icons.send, size: 18),
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
