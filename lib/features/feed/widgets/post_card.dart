import 'package:flutter/material.dart';
import '../models/post_model.dart';

import 'package:zuno/core/design/zuno_colors.dart';
import 'package:zuno/core/design/zuno_spacing.dart';
import 'package:zuno/core/design/zuno_text.dart';

import 'package:zuno/services/like_service.dart';
import 'package:zuno/services/comment_service.dart';
import 'package:zuno/features/comments/models/comment_model.dart';
import 'package:zuno/features/comments/widgets/comments_list.dart';
import 'package:flutter/animation.dart';

class FeedPostCard extends StatefulWidget {
  final PostModel post;

  const FeedPostCard({
    super.key,
    required this.post,
  });

  @override
  State<FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<FeedPostCard>
    with SingleTickerProviderStateMixin {
  final LikeService _likeService = LikeService();
  late TextEditingController _commentController;

  void _refreshComments() {
    setState(() {});
  }

  bool _isLiked = false;
  late int _likeCount;

  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _likeCount = widget.post.likeCount;
    _commentController = TextEditingController();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _loadLikeState();
  }

  Future<void> _loadLikeState() async {
    final liked = await _likeService.isPostLiked(widget.post.id);
    if (!mounted) return;
    setState(() => _isLiked = liked);
  }

  Future<void> _toggleLike() async {
    // ❤️ Optimistic UI
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    try {
      if (_isLiked) {
        await _likeService.likePost(widget.post.id);
      } else {
        await _likeService.unlikePost(widget.post.id);
      }
      // Refresh count from server to be safe
      final total = await _likeService.countLikes(widget.post.id);
      setState(() {
        _likeCount = total;
      });
    } catch (_) {
      // 🔁 rollback on error
      if (!mounted) return;
      setState(() {
        _isLiked = !_isLiked;
        _likeCount += _isLiked ? 1 : -1;
      });
    }
  }

  void _openComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ZunoColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Comments", style: ZunoText.heading()),
                const SizedBox(height: 16),

                Expanded(
                  child: Center(
                    child: Text(
                      "Comments UI coming next 👇",
                      style: ZunoText.body(),
                    ),
                  ),
                ),

                TextField(
                  decoration: InputDecoration(
                    hintText: "Add a comment...",
                    filled: true,
                    fillColor: ZunoColors.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;
    await CommentService().addComment(postId: widget.post.id, content: content);
    _commentController.clear();
    setState(() {}); // refresh comments
  }

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ZunoSpacing.lg),
      padding: EdgeInsets.all(ZunoSpacing.md),
      decoration: BoxDecoration(
        color: ZunoColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header
          Row(
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(width: 10),
              Text(
                widget.post.username ?? 'User',
                style: ZunoText.body(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔹 Caption
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.post.caption, style: ZunoText.body()),
              CommentsList(postId: widget.post.id),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔹 Actions
          Row(
            children: [
              ScaleTransition(
                scale: _scaleAnim,
                child: IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : Colors.grey,
                  ),
                ),
              ),
              Text('$_likeCount', style: ZunoText.caption()),

              const SizedBox(width: 16),

              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () => _openComments(context),
              ),
            ],
          ),

          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(onPressed: _sendComment, child: Text('Send')),
            ],
          ),
        ],
      ),
    );
  }
}
