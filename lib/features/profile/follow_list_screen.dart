import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zuno/models/profile_data.dart';
import 'package:zuno/services/profile_service.dart';

class FollowListScreen extends StatefulWidget {
  final String userId;
  final String mode; // 'followers' or 'following'
  const FollowListScreen({Key? key, required this.userId, required this.mode}) : super(key: key);

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  bool _loading = true;
  List<ProfileData> _people = [];
  String? _currentUserId = Supabase.instance.client.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Future<void> _loadList() async {
    final userId = widget.userId;
    List<String> ids = [];
    final sup = Supabase.instance.client;
    if (widget.mode == 'followers') {
      final res = await sup.from('follows').select('follower_id').eq('following_id', userId);
      ids = (res as List).map((m) => m['follower_id'] as String).toList();
    } else {
      final res = await sup.from('follows').select('following_id').eq('follower_id', userId);
      ids = (res as List).map((m) => m['following_id'] as String).toList();
    }
    if (ids.isEmpty) {
      setState(() { _loading = false; _people = []; });
      return;
    }
    List<ProfileData> list = [];
    for (final id in ids) {
      final p = await sup.from('profiles').select('id, username, avatar_url').eq('id', id).maybeSingle();
      if (p != null) {
        list.add(ProfileData.fromMap(p as Map<String, dynamic>));
      }
    }
    _people = list;
    setState(() { _loading = false; });
  }

  Future<void> _toggleFollow(String targetUserId) async {
    if (_currentUserId == null) return;
    await ProfileService().toggleFollow(_currentUserId!, targetUserId);
    await _loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.mode == 'followers' ? 'Followers' : 'Following')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _people.length,
              itemBuilder: (ctx, i) {
                final p = _people[i];
                final isMe = _currentUserId != null && _currentUserId == p.userId;
                return ListTile(
                  leading: CircleAvatar(backgroundImage: p.avatarUrl.isNotEmpty ? NetworkImage(p.avatarUrl) : null, child: p.avatarUrl.isEmpty ? const Icon(Icons.person) : null),
                  title: Text(p.username),
                  trailing: isMe
                      ? null
                      : ElevatedButton(
                          onPressed: () => _toggleFollow(p.userId),
                          child: const Text('Follow'),
                        ),
                );
              },
            ),
    );
  }
}
