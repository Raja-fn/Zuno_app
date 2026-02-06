import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zuno/models/profile_data.dart';
import 'package:zuno/services/profile_service.dart';
import 'edit_profile_screen.dart';
import 'follow_list_screen.dart';
import 'package:zuno/services/post_service.dart';
import 'package:zuno/features/feed/models/post_model.dart';
import 'package:zuno/shared/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _service = ProfileService();
  final _postService = PostService();
  ProfileData? _profile;
  List<PostModel> _posts = [];
  List<PostModel> _reels = [];
  bool _loadingProfile = true;
  bool _loadingPosts = true;
  bool _isOwner = false;
  bool _isFollowing = false;

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  bool get _isOwnProfile => _currentUserId != null && _currentUserId == widget.userId;

  @override
  void initState() {
    super.initState();
    _isOwner = _isOwnProfile;
    _loadProfile();
    _loadPosts();
  }

  Future<void> _loadProfile() async {
    final profile = await _service.fetchProfile(widget.userId);
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _loadingProfile = false;
    });
  }

  Future<void> _loadPosts() async {
    final posts = await _postService.fetchPostsByUser(widget.userId);
    if (!mounted) return;
    setState(() {
      _posts = posts;
      _reels = posts.where((p) => p.videoUrl != null && p.videoUrl!.isNotEmpty).toList();
      _loadingPosts = false;
    });
  }

  Future<void> _changeAvatar() async {
    if (!_isOwner) return;
    final file = await _service.pickAvatarImage();
    if (file == null) return;
    await _service.uploadAvatar(file, widget.userId);
    await _loadProfile();
  }

  Future<void> _toggleFollow() async {
    if (_currentUserId == null || _currentUserId == widget.userId) return;
    await _service.toggleFollow(_currentUserId!, widget.userId);
    final isNowFollowing = await _service.isFollowing(_currentUserId!, widget.userId);
    setState(() {
      _isFollowing = isNowFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingProfile) {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }
    final p = _profile;
    // UI: Instagram-like profile
    return Scaffold(
      appBar: AppBar(title: Text(p?.username ?? 'Profile')),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadProfile();
          await _loadPosts();
        },
        child: _buildProfileUI(p),
      ),
    );
  }

  Widget _buildProfileUI(ProfileData? profile) {
    final postsCount = _posts.length;
    final followers = profile?.followersCount ?? 0;
    final following = profile?.followingCount ?? 0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: (profile?.avatarUrl?.isNotEmpty ?? false)
                      ? NetworkImage(profile?.avatarUrl ?? '')
                      : null,
                  child: (profile?.avatarUrl?.isNotEmpty ?? false)
                      ? null
                      : const Icon(Icons.person, size: 40),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile?.username ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(profile?.bio ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: profile != null
                          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => FollowListScreen(userId: profile.userId, mode: 'followers')))
                          : null,
                      child: _StatTile(label: 'Followers', value: followers.toString()),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: profile != null
                          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => FollowListScreen(userId: profile.userId, mode: 'following')))
                          : null,
                      child: _StatTile(label: 'Following', value: following.toString()),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _isOwnProfile
                    ? ElevatedButton(onPressed: () {
                        if (_profile != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileScreen(profile: _profile!),
                            ),
                          ).then((_) => _loadProfile());
                        }
                      }, child: const Text('Edit Profile'))
                    : ElevatedButton(onPressed: _toggleFollow, child: Text(_isFollowing ? 'Following' : 'Follow')),
                const SizedBox(width: 8),
                _isOwnProfile
                    ? ElevatedButton(onPressed: _changeAvatar, child: const Text('Change Avatar'))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(tabs: [Tab(text: 'Posts'), Tab(text: 'Reels')]),
                SizedBox(
                  height: 260,
                  child: TabBarView(children: [
                    _buildPostsGrid(_posts),
                    _buildPostsGrid(_reels),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsGrid(List<PostModel> posts) {
    if (posts.isEmpty) return const Center(child: Text('No posts'));
    return GridView.builder(
      padding: const EdgeInsets.all(6),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [Text(value, style: const TextStyle(fontWeight: FontWeight.bold)), Text(label)],
      ),
    );
  }
}
