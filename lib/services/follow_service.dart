import 'package:supabase_flutter/supabase_flutter.dart';

class FollowService {
  final _supabase = Supabase.instance.client;

  Future<void> follow(String userId) async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return;

    await _supabase.from('follows').insert({
      'follower_id': currentUser.id,
      'following_id': userId,
    });
  }

  Future<void> unfollow(String userId) async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return;

    await _supabase.from('follows')
        .delete()
        .eq('follower_id', currentUser.id)
        .eq('following_id', userId);
  }

  Future<bool> isFollowing(String userId) async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return false;

    final res = await _supabase
        .from('follows')
        .select()
        .eq('follower_id', currentUser.id)
        .eq('following_id', userId)
        .maybeSingle();

    return res != null;
  }
}
