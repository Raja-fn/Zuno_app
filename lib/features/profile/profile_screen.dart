import 'package:flutter/material.dart';
import 'package:zuno/features/feed/models/post_model.dart';
import 'package:zuno/models/profile_data.dart';
import 'package:zuno/services/post_service.dart';
import 'package:zuno/services/profile_service.dart';
import 'package:zuno/shared/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<ProfileData?> _profileFuture;
  late Future<List<PostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadPosts();
  }

  void _loadProfile() {
    _profileFuture = ProfileService().fetchProfile(widget.userId);
  }

  void _loadPosts() {
    _postsFuture = PostService().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: FutureBuilder<ProfileData?>(
        future: _profileFuture,
        builder: (context, profileSnap) {
          if (profileSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileSnap.hasError) {
            return Center(child: Text(profileSnap.error.toString()));
          }

          final profile = profileSnap.data;

          if (profile == null) {
            return const Center(child: Text("Profile not found"));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(radius: 40),
                    const SizedBox(height: 8),
                    Text(
                      profile.username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(profile.bio ?? ''),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: FutureBuilder<List<PostModel>>(
                  future: _postsFuture,
                  builder: (context, postSnap) {
                    if (postSnap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (postSnap.hasError) {
                      return Center(child: Text(postSnap.error.toString()));
                    }

                    final posts = postSnap.data ?? [];

                    if (posts.isEmpty) {
                      return const Center(child: Text("No posts yet"));
                    }

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(post: posts[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
