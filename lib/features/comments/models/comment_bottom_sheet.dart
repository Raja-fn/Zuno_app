import 'package:flutter/material.dart';
import 'package:zuno/core/design/zuno_spacing.dart';
import 'package:zuno/core/design/zuno_text.dart';
import 'package:zuno/shared/ui/zuno_input.dart';
import 'package:zuno/shared/ui/zuno_button.dart';
import 'package:zuno/services/comment_service.dart';
import 'comment_model.dart';
import 'widgets/comment_tile.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;

  const CommentBottomSheet({super.key, required this.postId});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final CommentService _commentService = CommentService();
  final TextEditingController _controller = TextEditingController();

  bool _loading = true;
  List<CommentModel> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final data = await _commentService.fetchComments(widget.postId);
    setState(() {
      _comments = data;
      _loading = false;
    });
  }

  Future<void> _sendComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await _commentService.addComment(
      postId: widget.postId,
      content: text,
    );

    _controller.clear();
    _loadComments(); // refresh
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: ZunoSpacing.lg,
        right: ZunoSpacing.lg,
        top: ZunoSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Comments", style: ZunoText.heading()),
          SizedBox(height: ZunoSpacing.md),

          _loading
              ? const CircularProgressIndicator()
              : SizedBox(
                  height: 200, // small list area
                  child: ListView.builder(
                    itemCount: _comments.length,
                    itemBuilder: (_, i) => CommentTile(comment: _comments[i]),
                  ),
                ),

          SizedBox(height: ZunoSpacing.md),

          Row(
            children: [
              Expanded(
                child: ZunoInput(
                  hint: "Add a comment…",
                  controller: _controller,
                ),
              ),
              SizedBox(width: ZunoSpacing.md),
              ZunoButton(
                text: "Send",
                onPressed: _sendComment,
              ),
            ],
          ),

          SizedBox(height: ZunoSpacing.md),
        ],
      ),
    );
  }
}
