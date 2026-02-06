import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zuno/services/post_service.dart';
import 'package:zuno/services/profile_service.dart';

class PostCard extends StatefulWidget {
  final dynamic post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _liked = false;
  int _likes = 0;
  int _comments = 0;
  int _vibes = 0;
  String _postId = '';
  String _authorId = '';
  bool _isOwner = false;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    final p = widget.post;
    try {
      if (p is Map) {
        _postId = '${p['id'] ?? p['post_id'] ?? ''}';
        _likes = (p['likes_count'] ?? p['likesCount'] ?? 0) as int;
        _comments = (p['comments_count'] ?? p['commentsCount'] ?? 0) as int;
        _vibes = (p['vibe_count'] ?? p['vibes'] ?? 0) as int;
        _authorId = '${p['user_id'] ?? p['userId'] ?? ''}';
        _liked = (p['liked'] ?? false) as bool;
      } else {
        _postId = (p.id ?? '').toString();
        _authorId = (p.user_id ?? p.userId ?? '').toString();
        _liked = false;
        _likes = 0;
        _comments = 0;
        _vibes = 0;
      }
    } catch (_) {}
    final current = Supabase.instance.client.auth.currentUser?.id;
    _isOwner = current != null && _authorId.isNotEmpty && current == _authorId;
    if (!_isOwner && _authorId.isNotEmpty) {
      ProfileService().isFollowing(current ?? '', _authorId).then((v) {
        if (!mounted) return;
        setState(() => _isFollowing = v);
      });
    }
    _liked = (p is Map) ? (p['liked'] ?? false) as bool : false;
  }

  Future<void> _toggleLike() async {
    if (_postId.isEmpty) return;
    await PostService().toggleLike(_postId);
    setState(() {
      _liked = !_liked;
      _likes = _liked ? _likes + 1 : (_likes > 0 ? _likes - 1 : 0);
    });
  }

  Future<void> _toggleFollowAuthor() async {
    if (_authorId.isEmpty) return;
    final current = Supabase.instance.client.auth.currentUser?.id;
    if (current == null || current == _authorId) return;
    await ProfileService().toggleFollow(current, _authorId);
    final nowFollowing = await ProfileService().isFollowing(current, _authorId);
    if (mounted) setState(() => _isFollowing = nowFollowing);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post as dynamic;
    final imageUrl = (p is Map) ? (p['image_url'] ?? p['imageUrl'] ?? '') : '';
    final caption = (p is Map) ? (p['caption'] ?? '') : '';
    final username = (p is Map) ? (p['username'] ?? '') : '';
    final currentUser = Supabase.instance.client.auth.currentUser?.id;
    final authorId = (p is Map) ? (p['user_id'] ?? p['userId'] ?? '') : '';
    final showFollow = authorId.toString().isNotEmpty && currentUser != null && authorId.toString() != currentUser;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrl.isNotEmpty ? Image.network(imageUrl) : Container(height: 180, color: Colors.grey.shade200),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(caption.toString(), maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_liked ? Icons.favorite : Icons.favorite_border, color: _liked ? Colors.red : null),
                  onPressed: _toggleLike,
                ),
                Text('$_likes'),
                const SizedBox(width: 8),
                const Icon(Icons.comment_outlined),
                const SizedBox(width: 4),
                Text('$_comments'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
                  child: Text('Vibing Now: ${_vibes}'),
                ),
              ],
            ),
          ),
          if (showFollow)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: ElevatedButton(onPressed: _toggleFollowAuthor, child: Text(_isFollowing ? 'Following' : 'Follow')),
            ),
        ],
      ),
    );
  }
}
