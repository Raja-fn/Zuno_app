import 'package:supabase_flutter/supabase_flutter.dart';

class LikeService {
  final _client = Supabase.instance.client;

  Future<void> toggleLike(String postId, String userId) async {
    final existing = await _client
        .from('post_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();

    if (existing == null) {
      await _client.from('post_likes').insert({
        'post_id': postId,
        'user_id': userId,
      });
    } else {
      await _client
          .from('post_likes')
          .delete()
          .eq('id', existing['id']);
    }
  }
}
