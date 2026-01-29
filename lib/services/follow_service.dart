import 'package:supabase_flutter/supabase_flutter.dart';

class FollowService {
  final _client = Supabase.instance.client;

  Future<void> followUser(String targetUserId) async {
    await _client.from('follows').insert({
      'follower_id': _client.auth.currentUser!.id,
      'following_id': targetUserId,
    });
  }

  Future<void> unfollowUser(String targetUserId) async {
    await _client
        .from('follows')
        .delete()
        .eq('follower_id', _client.auth.currentUser!.id)
        .eq('following_id', targetUserId);
  }

  Future<bool> isFollowing(String targetUserId) async {
    final res = await _client
        .from('follows')
        .select()
        .eq('follower_id', _client.auth.currentUser!.id)
        .eq('following_id', targetUserId)
        .maybeSingle();

    return res != null;
  }

  Future<int> followersCount(String userId) async {
    final res = await _client
        .from('follows')
        .select()
        .eq('following_id', userId);

    return res.length;
  }

  Future<int> followingCount(String userId) async {
    final res = await _client
        .from('follows')
        .select()
        .eq('follower_id', userId);

    return res.length;
  }
}
