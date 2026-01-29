import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarService {
  final _client = Supabase.instance.client;

  Future<String> uploadAvatar(File file, String userId) async {
    final path = '$userId/avatar.jpg';

    await _client.storage
        .from('avatars')
        .upload(
      path,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    return _client.storage
        .from('avatars')
        .getPublicUrl(path);
  }

  Future<void> updateAvatarUrl(
      String userId, String avatarUrl) async {
    await _client
        .from('profiles')
        .update({'avatar_url': avatarUrl})
        .eq('id', userId);
  }

  Future<String?> getAvatar(String userId) async {
    final res = await _client
        .from('profiles')
        .select('avatar_url')
        .eq('id', userId)
        .maybeSingle();

    return res?['avatar_url'];
  }
}
