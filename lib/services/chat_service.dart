import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final _supabase = Supabase.instance.client;

  String get currentUserId => _supabase.auth.currentUser!.id;

  /// Get all chats for current user
  Future<List<Map<String, dynamic>>> fetchChats() async {
    final res = await _supabase
        .from('direct_message_threads')
        .select('''
          id,
          user1,
          user2,
          direct_messages (
            message,
            created_at
          )
        ''')
        .or('user1.eq.$currentUserId,user2.eq.$currentUserId')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  /// Create or return existing chat
  Future<String> getOrCreateChat({
    required String otherUserId, required String currentUserId,
  }) async {
    final existing = await _supabase
        .from('direct_message_threads')
        .select()
        .or(
      'and(user1.eq.$currentUserId,user2.eq.$otherUserId),'
          'and(user1.eq.$otherUserId,user2.eq.$currentUserId)',
    )
        .maybeSingle();

    if (existing != null) return existing['id'];

    final created = await _supabase
        .from('direct_message_threads')
        .insert({
      'user1': currentUserId,
      'user2': otherUserId,
    })
        .select()
        .single();

    return created['id'];
  }
}
