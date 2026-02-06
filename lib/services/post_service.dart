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
  // SIMPLE FEED
  // ─────────────────────────
  Future<List<PostModel>> fetchPosts() async {
    final currentUserId = _supabase.auth.currentUser?.id;

    final res = await _supabase
        .from('posts')
        .select('''
          id,
          image_url,
          caption,
          username,
          created_at,
          likes_count,
          comments_count,
          likes(user_id)
        ''')
        .order('created_at', ascending: false);

    return res
        .map<PostModel>(
          (e) => PostModel.fromMap(e, currentUserId: currentUserId),
    )
        .toList();
  }

  // ─────────────────────────
  // PAGINATED FEED
  // ─────────────────────────
  Future<List<PostModel>> fetchPostsPaged({
    required int limit,
    required int offset,
  }) async {
    final currentUserId = _supabase.auth.currentUser?.id;

    final res = await _supabase
        .from('posts')
        .select('''
          id,
          image_url,
          caption,
          username,
          created_at,
          likes_count,
          comments_count,
          likes(user_id)
        ''')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return res
        .map<PostModel>(
          (e) => PostModel.fromMap(e, currentUserId: currentUserId),
    )
        .toList();
  }

  // Like toggling for a post by current user
  Future<void> toggleLike(String postId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    final res = await _supabase.from('likes').select('id').eq('post_id', postId).eq('user_id', userId).maybeSingle();
    if (res != null && res['id'] != null) {
      await _supabase.from('likes').delete().eq('id', res['id']);
    } else {
      await _supabase.from('likes').insert({'post_id': postId, 'user_id': userId});
    }
  }

  // Lightweight helper for simple post creation API
  Future<void> createPostSimple({required String caption, String? imageUrl}) async {
    final userId = _supabase.auth.currentUser!.id;
    await _supabase.from('posts').insert({
      'user_id': userId,
      'caption': caption,
      'image_url': imageUrl,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  // ─────────────────────────
  // REELS FEED (VIDEOS)
  // ─────────────────────────
  Future<List<PostModel>> fetchReelsPaged({
    required int limit,
    required int offset,
  }) async {
    // For now, fetch posts and filter those with a non-null video_url
    final all = await fetchPostsPaged(limit: limit, offset: offset);
    return all.where((p) => p.videoUrl != null && p.videoUrl!.isNotEmpty).toList();
  }

  // ─────────────────────────
  // PROFILE POSTS
  // ─────────────────────────
  Future<List<PostModel>> fetchPostsByUser(String userId) async {
    final currentUserId = _supabase.auth.currentUser?.id;

    final res = await _supabase
        .from('posts')
        .select('''
          id,
          image_url,
          caption,
          username,
          created_at,
          likes_count,
          comments_count,
          likes(user_id)
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return res
        .map<PostModel>(
          (e) => PostModel.fromMap(e, currentUserId: currentUserId),
    )
        .toList();
  }

  // ─────────────────────────
  // TRENDING FEED
  // ─────────────────────────
  Future<List<PostModel>> fetchTrendingPosts({
    required int limit,
  }) async {
    final currentUserId = _supabase.auth.currentUser?.id;

    final res = await _supabase
        .from('posts')
        .select('''
          id,
          image_url,
          caption,
          username,
          created_at,
          likes_count,
          comments_count,
          likes(user_id)
        ''')
        .order('likes_count', ascending: false)
        .limit(limit);

    return res
        .map<PostModel>(
          (e) => PostModel.fromMap(e, currentUserId: currentUserId),
    )
        .toList();
  }

  // ─────────────────────────
  // PERSONALIZED FEED (fallback logic)
  // ─────────────────────────
  Future<List<PostModel>> fetchPersonalizedFeed({
    required int limit,
  }) async {
    // For now: same as trending / recent
    return fetchTrendingPosts(limit: limit);
  }
}
