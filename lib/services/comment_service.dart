import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zuno/features/comments/models/comment_model.dart';

class CommentService {
  final _supabase = Supabase.instance.client;

  Stream<List<CommentModel>> commentsStream(String postId) {
    return _supabase
        .from('comments')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at')
        .map((data) {
      return data.map<CommentModel>((e) {
        return CommentModel.fromMap(e);
      }).toList();
    });
  }

  Future<void> addComment({
    required String postId,
    required String content,
  }) async {
    final user = _supabase.auth.currentUser!;

    await _supabase.from('comments').insert({
      'post_id': postId,
      'user_id': user.id,
      'username': user.email ?? 'user',
      'content': content,
    });
  }
}
