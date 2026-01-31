import 'package:flutter/material.dart';
import 'package:zuno/features/feed/models/post_model.dart';
import 'package:zuno/services/post_service.dart';
import 'package:zuno/shared/post_card.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  late Future<List<PostModel>> _trendingFuture;

  @override
  void initState() {
    super.initState();
    _trendingFuture = PostService().fetchTrendingPosts(limit: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trending 🔥")),
      body: FutureBuilder<List<PostModel>>(
        future: _trendingFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!;

          if (posts.isEmpty) {
            return const Center(child: Text("No trending posts"));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: posts[index]);
            },
          );
        },
      ),
    );
  }
}
