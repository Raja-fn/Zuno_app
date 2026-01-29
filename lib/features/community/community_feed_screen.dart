import 'package:flutter/material.dart';
import '../../shared/post_card.dart';
import '../../services/post_service.dart';
import '../../models/post_data.dart';

class CommunityFeedScreen extends StatefulWidget {
  final String title;
  final String community;

  const CommunityFeedScreen({
    super.key,
    required this.title,
    required this.community,
  });

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  late Future<List<PostData>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture =
        PostService().fetchPostsByCommunity(widget.community);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<List<PostData>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No posts in this community yet"),
            );
          }

          final posts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                postId: post.id,
                username: post.username,
                time: post.time,
                imageUrl: post.imageUrl,
                likes: post.likes,
                comments: post.comments,
              );
            },
          );
        },
      ),
    );
  }
}
