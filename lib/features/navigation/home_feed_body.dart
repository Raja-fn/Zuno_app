import 'package:flutter/material.dart';
import 'package:zuno/services/post_service.dart';
import 'package:zuno/shared/post_card.dart';
import 'package:zuno/features/feed/models/post_model.dart';

class HomeFeedBody extends StatefulWidget {
  const HomeFeedBody({Key? key}) : super(key: key);

  @override
  State<HomeFeedBody> createState() => _HomeFeedBodyState();
}

class _HomeFeedBodyState extends State<HomeFeedBody> {
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

  @override
  Widget build(BuildContext context) {
    if (_loading && _posts.isEmpty) return const Center(child: CircularProgressIndicator());
    return GridView.builder(
      padding: const EdgeInsets.all(6),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.8,
      ),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: _posts[index]);
      },
    );
  }
}
