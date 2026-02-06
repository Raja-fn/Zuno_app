import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final userId = _supabase.auth.currentUser!.id;

    final res = await _supabase
        .from('notifications')
        .select('*, actor:profiles(username)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> markAsRead(String id) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id);
  }
}
