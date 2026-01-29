import 'package:flutter/material.dart';
import '../../shared/post_card.dart';
import '../../services/post_service.dart';
import '../../models/post_data.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  late Future<List<PostData>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = PostService().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Trending 🔥",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<List<PostData>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No trending posts yet",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          /// 🔥 SORT BY LIKES
          final posts = [...snapshot.data!];
          posts.sort((a, b) => b.likes.compareTo(a.likes));

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _postsFuture = PostService().fetchPosts();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  postId: post.id,
                  username: post.username,
                  imageUrl: post.imageUrl,
                  likes: post.likes,
                  comments: post.comments,
                  time: post.time,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
