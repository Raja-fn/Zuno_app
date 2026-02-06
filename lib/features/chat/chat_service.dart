import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final _supabase = Supabase.instance.client;

  Future<String> getOrCreateChat({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final existing = await _supabase
        .from('direct_message_threads')
        .select()
        .or(
      'and(user1.eq.$currentUserId,user2.eq.$otherUserId),'
          'and(user1.eq.$otherUserId,user2.eq.$currentUserId)',
    )
        .maybeSingle();

    if (existing != null) {
      return existing['id'];
    }

    final created = await _supabase
        .from('direct_message_threads')
        .insert({
      'user1': currentUserId,
      'user2': otherUserId,
    })
        .select()
        .single();

    // 🔹 initialize read state
    await _supabase.from('message_reads').insert([
      {
        'chat_id': created['id'],
        'user_id': currentUserId,
      },
      {
        'chat_id': created['id'],
        'user_id': otherUserId,
      },
    ]);

    return created['id'];
  }
}
