import 'package:supabase_flutter/supabase_flutter.dart';

class FeedService {
  final _supabase = Supabase.instance.client;

  /// Normal fetch (used on first load)
  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final data = await _supabase
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  /// Realtime stream
  Stream<List<Map<String, dynamic>>> streamPosts() {
    return _supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }
}
