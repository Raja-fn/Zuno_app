import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zuno/features/feed/models/post_model.dart';

class PostService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ─────────────────────────
  // CREATE POST
  // ─────────────────────────
  Future<void> createPost({
    required String imageUrl,
    required String caption,
    required String username,
    required List<String> topics,
  }) async {
    final userId = _supabase.auth.currentUser!.id;

    await _supabase.from('posts').insert({
      'image_url': imageUrl,
      'caption': caption,
      'username': username,
      'user_id': userId,
      'topics': topics,
    });
  }

  // ─────────────────────────
  // NORMAL FEED (PAGINATED)
  // ─────────────────────────
  Future<List<PostModel>> fetchPostsPaged({
    required int limit,
    required int offset,
  }) async {
    final userId = _supabase.auth.currentUser?.id;

    final response = await _supabase
        .from('posts')
        .select('''
          id,
          image_url,
          caption,
          username,
          created_at,
          likes_count,
          comments_count,
          likes ( user_id )
        ''')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return response.map<PostModel>((e) {
      return PostModel.fromMap(e, currentUserId: userId);
    }).toList();
  }

  // ─────────────────────────
  // SIMPLE FEED (NON-PAGINATED)
  // ─────────────────────────
  Future<List<PostModel>> fetchPosts() async {
    final userId = _supabase.auth.currentUser?.id;

    final response = await _supabase
        .from('posts')
        .select('''
          id,
          image_url,
          caption,
          username,
          created_at,
          likes_count,
          comments_count,
          likes ( user_id )
        ''')
        .order('created_at', ascending: false);

    return response.map<PostModel>((e) {
      return PostModel.fromMap(e, currentUserId: userId);
    }).toList();
  }

  // ─────────────────────────
  // PROFILE FEED
  // ─────────────────────────
  Future<List<PostModel>> fetchPostsByUser(String userId) async {
    final response = await _supabase
        .from('posts')
        .select('''
          id,
          image_url,
          caption,
          username,
          created_at,
          likes_count,
          comments_count,
          likes ( user_id )
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response.map<PostModel>((e) {
      return PostModel.fromMap(e, currentUserId: userId);
    }).toList();
  }

  // ─────────────────────────
  // TRENDING FEED
  // ─────────────────────────
  Future<List<PostModel>> fetchTrendingPosts({
    required int limit,
  }) async {
    final userId = _supabase.auth.currentUser?.id;

    final response = await _supabase.rpc(
      'get_trending_posts',
      params: {'limit_count': limit},
    );

    return response.map<PostModel>((e) {
      return PostModel.fromMap(e, currentUserId: userId);
    }).toList();
  }

  // ─────────────────────────
  // PERSONALIZED FEED
  // ─────────────────────────
  Future<List<PostModel>> fetchPersonalizedFeed({
    required int limit,
  }) async {
    final userId = _supabase.auth.currentUser!.id;

    final response = await _supabase.rpc(
      'get_personalized_feed',
      params: {
        'uid': userId,
        'limit_count': limit,
      },
    );

    return response.map<PostModel>((e) {
      return PostModel.fromMap(e, currentUserId: userId);
    }).toList();
  }
}
