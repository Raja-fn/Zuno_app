import 'package:supabase_flutter/supabase_flutter.dart';

class FollowService {
  final _supabase = Supabase.instance.client;

  Future<void> follow(String userId) async {
    final currentUser = _supabase.auth.currentUser!.id;

    await _supabase.from('follows').insert({
      'follower_id': currentUser,
      'following_id': userId,
    });
  }

  Future<void> unfollow(String userId) async {
    final currentUser = _supabase.auth.currentUser!.id;

    await _supabase
        .from('follows')
        .delete()
        .match({
      'follower_id': currentUser,
      'following_id': userId,
    });
  }

  Future<bool> isFollowing(String userId) async {
    final currentUser = _supabase.auth.currentUser!.id;

    final res = await _supabase
        .from('follows')
        .select()
        .match({
      'follower_id': currentUser,
      'following_id': userId,
    })
        .maybeSingle();

    return res != null;
  }

  Future<int> followersCount(String userId) async {
    final res = await _supabase.rpc('followers_count', params: {'uid': userId});
    return res as int;
  }

  Future<int> followingCount(String userId) async {
    final res = await _supabase.rpc('following_count', params: {'uid': userId});
    return res as int;
  }
}
