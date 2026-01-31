import 'package:flutter/material.dart';
import 'package:zuno/features/comments/models/comment_model.dart';
import 'package:zuno/services/comment_service.dart';

class CommentsSheet extends StatefulWidget {
  final String postId;

  const CommentsSheet({super.key, required this.postId});

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendComment() async {
    if (_controller.text.trim().isEmpty) return;

    await CommentService().addComment(
      postId: widget.postId,
      content: _controller.text.trim(),
    );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              "Comments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // 🔥 REAL-TIME COMMENTS
            Expanded(
              child: StreamBuilder<List<CommentModel>>(
                stream: CommentService()
                    .commentsStream(widget.postId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final comments = snapshot.data!;

                  if (comments.isEmpty) {
                    return const Center(
                      child: Text("No comments yet"),
                    );
                  }

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final c = comments[index];
                      return ListTile(
                        title: Text(
                          c.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(c.content),
                      );
                    },
                  );
                },
              ),
            ),

            // Input
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Add a comment...",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendComment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
