import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_data.dart';

class ProfileService {
  final _client = Supabase.instance.client;

  /// GET PROFILE (used everywhere)
  Future<ProfileData?> fetchProfile(String userId) async {
    final res = await _client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (res == null) return null;
    return ProfileData.fromMap(res);
  }

  /// UPDATE / INSERT PROFILE
  Future<void> updateProfile(ProfileData profile) async {
    await _client.from('profiles').upsert(profile.toMap());
  }
}
