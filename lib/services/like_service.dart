import 'package:supabase_flutter/supabase_flutter.dart';

class LikeService {
  final _supabase = Supabase.instance.client;

  Future<void> toggleLike({
    required String postId,
    required bool isCurrentlyLiked,
  }) async {
    final userId = _supabase.auth.currentUser!.id;

    if (isCurrentlyLiked) {
      await _supabase
          .from('likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);
    } else {
      await _supabase.from('likes').insert({
        'post_id': postId,
        'user_id': userId,
      });
    }
  }
}
