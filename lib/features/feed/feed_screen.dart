import 'package:flutter/material.dart';
import 'package:zuno/services/post_service.dart';
import 'package:zuno/shared/post_card.dart';
import 'package:zuno/features/post/post_compose_screen.dart';
import 'package:zuno/features/feed/models/post_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<PostModel> _posts = [];
  bool _loading = false;
  int _offset = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _loading = true);
    final posts = await PostService().fetchPostsPaged(limit: _pageSize, offset: _offset);
    if (!mounted) return;
    setState(() {
      _posts = posts;
      _offset += posts.length;
      _loading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _posts.clear();
      _offset = 0;
    });
    await _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latest')),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
          onRefresh: _refresh,
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.9,
            ),
            itemCount: _posts.length,
            itemBuilder: (ctx, i) => PostCard(post: _posts[i]),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostComposeScreen())),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
