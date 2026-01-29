import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/comment_data.dart';

class CommentService {
  final SupabaseClient _client = Supabase.instance.client;

  /// 📥 FETCH COMMENTS (INITIAL LOAD)
  Future<List<CommentData>> fetchComments(String postId) async {
    final res = await _client
        .from('comments')
        .select()
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    return res
        .map<CommentData>((e) => CommentData.fromJson(e))
        .toList();
  }

  /// 🔴 REALTIME COMMENTS STREAM
  Stream<List<CommentData>> streamComments(String postId) {
    return _client
        .from('comments')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at', ascending: true)
        .map(
          (rows) => rows
          .map<CommentData>((e) => CommentData.fromJson(e))
          .toList(),
    );
  }

  /// ➕ ADD COMMENT
  Future<void> addComment({
    required String postId,
    required String username,
    required String content,
  }) async {
    await _client.from('comments').insert({
      'post_id': postId,
      'username': username,
      'content': content,
    });
  }
}

