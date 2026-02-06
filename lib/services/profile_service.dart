import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zuno/models/profile_data.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<File?> pickAvatarImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  Future<void> uploadAvatar(File file, String userId) async {
    final path = '$userId/avatar.jpg';

    await _supabase.storage.from('avatars').upload(
      path,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    final avatarUrl =
    _supabase.storage.from('avatars').getPublicUrl(path);

    await _supabase
        .from('profiles')
        .update({'avatar_url': avatarUrl})
        .eq('id', userId);
  }

  Future<ProfileData?> fetchProfile(String userId) async {
    final res = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (res == null) return null;
    return ProfileData.fromMap(res);
  }
  Future<void> updateProfile({
    required String username,
    required String bio,
    required String city,
    required String college,
    String? userId,
  }) async {
    final uid = userId ?? _supabase.auth.currentUser?.id;
    if (uid == null) {
      throw Exception('No userId available to update profile');
    }

    await _supabase.from('profiles').update({
      'username': username,
      'bio': bio,
      'city': city,
      'college': college,
    }).eq('id', uid);
  }

  // ─────────────────────────
  // FOLLOWING OPERATIONS
  // ─────────────────────────
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    try {
      final res = await _supabase
          .from('follows')
          .select('id')
          .eq('follower_id', currentUserId)
          .eq('following_id', targetUserId)
          .maybeSingle();
      return res != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    final following = await isFollowing(currentUserId, targetUserId);
    if (following) {
      // Unfollow: delete the relation and decrement counts
      final res = await _supabase
          .from('follows')
          .select('id')
          .eq('follower_id', currentUserId)
          .eq('following_id', targetUserId)
          .maybeSingle();
      if (res != null && res['id'] != null) {
        await _supabase.from('follows').delete().eq('id', res['id']);
      }
      // Decrement counts (safe guards)
      final targetProfile = await _supabase.from('profiles').select('followers_count').eq('id', targetUserId).maybeSingle();
      final currentProfile = await _supabase.from('profiles').select('following_count').eq('id', currentUserId).maybeSingle();
      int fc = (targetProfile?['followers_count'] ?? 0);
      int mc = (currentProfile?['following_count'] ?? 0);
      fc = fc > 0 ? fc - 1 : 0;
      mc = mc > 0 ? mc - 1 : 0;
      await _supabase.from('profiles').update({'followers_count': fc}).eq('id', targetUserId);
      await _supabase.from('profiles').update({'following_count': mc}).eq('id', currentUserId);
    } else {
      // Follow: create relation and increment counts
      await _supabase.from('follows').insert({
        'follower_id': currentUserId,
        'following_id': targetUserId,
      });
      // Increment counts
      final targetProfile = await _supabase.from('profiles').select('followers_count').eq('id', targetUserId).maybeSingle();
      final currentProfile = await _supabase.from('profiles').select('following_count').eq('id', currentUserId).maybeSingle();
      int fc = (targetProfile?['followers_count'] ?? 0);
      int mc = (currentProfile?['following_count'] ?? 0);
      fc = fc + 1;
      mc = mc + 1;
      await _supabase.from('profiles').update({'followers_count': fc}).eq('id', targetUserId);
      await _supabase.from('profiles').update({'following_count': mc}).eq('id', currentUserId);
    }
  }
}
