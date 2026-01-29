import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/post_card.dart';
import '../../services/post_service.dart';
import '../../services/follow_service.dart';
import '../../services/profile_service.dart';

import '../../models/post_data.dart';
import '../../models/profile_data.dart';

import '../auth/login_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import 'edit_profile_screen.dart';
import 'followers_screen.dart';
import 'following_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final User _user;
  late Future<List<PostData>> _postsFuture;

  ProfileData? _profile;
  bool _loadingProfile = true;

  int postCount = 0;
  int followers = 0;
  int following = 0;

  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _user = Supabase.instance.client.auth.currentUser!;
    _postsFuture = _loadPosts();
    _loadProfile();
    _loadFollowCounts();
  }

  /// LOAD PROFILE
  Future<void> _loadProfile() async {
    final data = await ProfileService().fetchProfile(_user.id);
    if (mounted) {
      setState(() {
        _profile = data;
        _loadingProfile = false;
      });
    }
  }

  /// LOAD POSTS
  Future<List<PostData>> _loadPosts() async {
    final posts =
    await PostService().fetchPosts();
    postCount = posts.length;
    return posts;
  }

  /// FOLLOW COUNTS
  Future<void> _loadFollowCounts() async {
    final service = FollowService();
    followers = await service.followersCount(_user.id);
    following = await service.followingCount(_user.id);
    if (mounted) setState(() {});
  }

  /// LOGOUT
  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
    );
  }

  /// OPEN POST (FIXED)
  void _openPost(PostData post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: PostCard(
          postId: post.id,
          username: post.username,
          imageUrl: post.imageUrl,
          likes: post.likes,
          comments: post.comments,
          time: post.time,
        )
      ),
    );
  }

  Widget _countTile(String label, int count, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildGrid(List<PostData> posts) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: posts.length,
      itemBuilder: (_, i) {
        final post = posts[i];
        return GestureDetector(
          onTap: () => _openPost(post),
          child: Image.network(post.imageUrl, fit: BoxFit.cover),
        );
      },
    );
  }

  Widget _buildList(List<PostData> posts) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: posts.length,
      itemBuilder: (_, i) {
        final post = posts[i];
        return PostCard(
          postId: post.id,
          username: post.username,
          imageUrl: post.imageUrl,
          likes: post.likes,
          comments: post.comments,
          time: post.time,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events, color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const LeaderboardScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 8),
                Text(
                  _profile?.username ?? _user.email ?? "User",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_profile?.bio.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _profile!.bio,
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_profile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "${_profile!.city} · ${_profile!.college}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _countTile("Posts", postCount, () {}),
                    _countTile("Followers", followers, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FollowersScreen()),
                      );
                    }),
                    _countTile("Following", following, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FollowingScreen()),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EditProfileScreen()),
                    );
                    if (updated == true) _loadProfile();
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PostData>>(
              future: _postsFuture,
              builder: (_, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No posts yet"));
                }
                final posts = snapshot.data!;
                return _isGridView
                    ? _buildGrid(posts)
                    : _buildList(posts);
              },
            ),
          ),
        ],
      ),
    );
  }
}
