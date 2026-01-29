import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_data.dart';

class PostService {
  final _client = Supabase.instance.client;

  Future<List<PostData>> fetchPosts() async {
    final res = await _client
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    return (res as List).map((p) {
      return PostData(
        id: p['id'].toString(),
        username: p['username'] ?? 'User',
        imageUrl: p['image_url'],
        likes: p['likes'] ?? 0,
        comments: p['comments'] ?? 0,
        time: 'Just now',
      );
    }).toList();
  }

  Future<void> createPost({
    required String username,
    required String imageUrl,
  }) async {
    await _client.from('posts').insert({
      'username': username,
      'image_url': imageUrl,
      'likes': 0,
      'comments': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
