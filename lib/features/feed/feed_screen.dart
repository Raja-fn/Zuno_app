import 'package:flutter/material.dart';
import '../../services/post_service.dart';
import '../../models/post_data.dart';
import '../../shared/post_card.dart';
import '../post/create_post_screen.dart';


class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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
        title: const Text("Feed"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // notifications screen
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // your feed UI (tabs, stories, posts)
        ],
      ),

      // 🔥 THIS WAS MISSING
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreatePostScreen(),
            ),
          );
        },
      ),
    );
  }
}
